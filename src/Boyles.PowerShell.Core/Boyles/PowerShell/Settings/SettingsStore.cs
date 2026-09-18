using System.Collections.Concurrent;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.Settings
{
    /// <summary>
    /// Central, process-wide store for Boyles.PowerShell settings. Backed by
    /// <see cref="ISettingsPersistence"/> (a JSON file on disk by default) so that a value set
    /// from PowerShell via Set-BPSSetting is immediately visible to every HttpClientBase-derived
    /// client running in the same process, and persists across sessions without any extra plumbing.
    /// Consumers inside Boyles.PowerShell.Core (and sub-modules such as Boyles.PowerShell.Hudu)
    /// should read through <see cref="Instance"/> and the typed convenience properties, such as
    /// <see cref="DebugEnabled"/>, falling back to <see cref="GetValue{T}"/> for ad-hoc settings
    /// that don't warrant their own property yet.
    /// </summary>
    public sealed class SettingsStore
    {
        /// <summary>
        /// Process-wide singleton, backed by the default JSON-file persistence. This is the
        /// instance every PowerShell cmdlet and HTTP client in Boyles.PowerShell.Core reads from
        /// and writes to; construct a private <see cref="BpsSettingsStore"/> directly only for
        /// tests that need isolation from the real on-disk file.
        /// </summary>
        public static SettingsStore Instance { get; } = new SettingsStore(new JsonFileSettingsPersistence());

        /// <summary>
        /// Storage backend this instance loads from and saves to.
        /// </summary>
        private readonly ISettingsPersistence _persistence;

        /// <summary>
        /// In-memory copy of every setting as raw JSON tokens, keyed case-insensitively so that
        /// PowerShell callers (which are themselves case-insensitive) never create accidental
        /// duplicate entries. JToken is used throughout, rather than plain object, to match the
        /// JObject/JToken conventions already used across HttpClientBase and the API clients.
        /// </summary>
        private readonly ConcurrentDictionary<string, JToken?> _values;

        /// <summary>
        /// Serializes writes to the backing store so two near-simultaneous Set/Remove calls
        /// cannot interleave their file writes and corrupt the persisted JSON.
        /// </summary>
        private readonly object _saveLock = new();

        /// <summary>
        /// Initializes a new store around the given persistence backend, immediately loading
        /// whatever was previously saved. Public so tests (or a host that wants a non-default
        /// backend, e.g. in-memory) can construct an isolated store rather than sharing the real
        /// on-disk <see cref="Instance"/>.
        /// </summary>
        /// <param name="persistence">Storage backend to load from and save to.</param>
        public SettingsStore(ISettingsPersistence persistence)
        {
            _persistence = persistence ?? throw new ArgumentNullException(nameof(persistence));
            _values = new ConcurrentDictionary<string, JToken?>(_persistence.Load(), StringComparer.OrdinalIgnoreCase);
        }

        /// <summary>
        /// Full path to the file this store persists to. Surfaced for troubleshooting via the
        /// Get-BPSSettingPath cmdlet.
        /// </summary>
        public string SettingsFilePath => _persistence.FilePath;

        /// <summary>
        /// When true, HttpClientBase-derived clients and PowerShell cmdlets that check this flag
        /// should emit verbose debug output (request/response detail, retry decisions, etc.).
        /// Defaults to false so debug output stays opt-in. This is the settings system's first
        /// consumer and doubles as the reference example for adding further typed settings.
        /// </summary>
        public bool DebugEnabled
        {
            get => GetValue(nameof(DebugEnabled), false);
            set => SetValue(nameof(DebugEnabled), value);
        }

        /// <summary>
        /// Retrieves a setting and converts it to <typeparamref name="T"/> via
        /// <see cref="JToken.ToObject{T}()"/>, returning <paramref name="defaultValue"/> when the
        /// setting has never been set or fails to convert.
        /// </summary>
        /// <param name="name">Name of the setting to retrieve.</param>
        /// <param name="defaultValue">Value returned when the setting is absent or unconvertible.</param>
        public T GetValue<T>(string name, T defaultValue = default!)
        {
            ValidateName(name);

            if (!_values.TryGetValue(name, out var token) || token is null || token.Type == JTokenType.Null)
            {
                return defaultValue;
            }

            try
            {
                var converted = token.ToObject<T>();
                return converted is null ? defaultValue : converted;
            }
            catch (JsonException)
            {
                return defaultValue;
            }
        }

        /// <summary>
        /// Retrieves a setting's raw stored value with no target-type conversion, or null when it
        /// has never been set. Scalar values (bool, string, number) are unwrapped to their plain
        /// CLR type; object/array values are returned as their underlying <see cref="JToken"/>.
        /// Intended for PowerShell callers and other untyped consumers; C# callers that know the
        /// expected type should prefer <see cref="GetValue{T}"/>.
        /// </summary>
        /// <param name="name">Name of the setting to retrieve.</param>
        public object? GetRaw(string name)
        {
            ValidateName(name);

            if (!_values.TryGetValue(name, out var token) || token is null || token.Type == JTokenType.Null)
            {
                return null;
            }

            return token is JValue scalar ? scalar.Value : token;
        }

        /// <summary>
        /// Sets a setting to the given value and persists the change immediately. Any
        /// JSON-serializable value is accepted (including an already-constructed JToken); passing
        /// null is equivalent to leaving the setting unset for the purposes of
        /// <see cref="GetValue{T}"/> and <see cref="GetRaw"/>.
        /// </summary>
        /// <param name="name">Name of the setting to set.</param>
        /// <param name="value">Value to store.</param>
        public void SetValue(string name, object? value)
        {
            ValidateName(name);

            _values[name] = value switch
            {
                null => null,
                JToken token => token,
                _ => JToken.FromObject(value)
            };

            Save();
        }

        /// <summary>
        /// Removes a single setting, reverting it to whichever default the reading code supplies
        /// (or to a type default for direct <see cref="GetRaw"/> callers). Returns false when the
        /// setting was not present, in which case no save is performed.
        /// </summary>
        /// <param name="name">Name of the setting to remove.</param>
        public bool RemoveValue(string name)
        {
            ValidateName(name);

            var removed = _values.TryRemove(name, out _);
            if (removed)
            {
                Save();
            }

            return removed;
        }

        /// <summary>
        /// Clears every setting and persists the now-empty store. Prefer <see cref="RemoveValue"/>
        /// when only a single setting needs to be reverted.
        /// </summary>
        public void ResetAll()
        {
            _values.Clear();
            Save();
        }

        /// <summary>
        /// Returns a snapshot of every currently stored setting, unwrapped the same way as
        /// <see cref="GetRaw"/> (scalars to their plain CLR type, objects/arrays as JToken). The
        /// returned dictionary is a copy; mutating it has no effect on the store.
        /// </summary>
        public IReadOnlyDictionary<string, object?> GetAll()
        {
            var result = new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase);

            foreach (var kvp in _values)
            {
                result[kvp.Key] = kvp.Value is JValue scalar ? scalar.Value : kvp.Value;
            }

            return result;
        }

        /// <summary>
        /// Writes the current in-memory state to the backing persistence, guarded by
        /// <see cref="_saveLock"/> so concurrent mutators cannot corrupt the file.
        /// </summary>
        private void Save()
        {
            lock (_saveLock)
            {
                _persistence.Save(_values);
            }
        }

        /// <summary>
        /// Validates that a setting name was actually supplied, throwing early with a clear message
        /// rather than letting a blank key silently succeed or fail deep inside the dictionary.
        /// </summary>
        /// <param name="name">Setting name to validate.</param>
        private static void ValidateName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                throw new ArgumentException("Setting name is required.", nameof(name));
            }
        }
    }
}
