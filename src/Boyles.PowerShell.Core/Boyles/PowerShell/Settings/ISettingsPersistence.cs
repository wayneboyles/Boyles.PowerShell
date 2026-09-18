using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.Settings
{
    /// <summary>
    /// Storage backend contract used by <see cref="SettingsStore"/>. The default implementation,
    /// <see cref="JsonFileSettingsPersistence"/>, persists to a per-user JSON file on disk. Tests
    /// or hosts that want a different backend (in-memory, registry, a database row) can implement
    /// this interface and construct a <see cref="SettingsStore"/> around it directly rather than
    /// using the process-wide <see cref="SettingsStore.Instance"/>.
    /// </summary>
    public interface ISettingsPersistence
    {
        /// <summary>
        /// Full path to the underlying settings file. Exposed so callers can surface it for
        /// troubleshooting (see the Get-BPSSettingPath cmdlet).
        /// </summary>
        string FilePath { get; }

        /// <summary>
        /// Loads every persisted setting as raw <see cref="JToken"/> values. Returns an empty,
        /// case-insensitive dictionary when nothing has been saved yet rather than throwing, so a
        /// fresh install starts clean.
        /// </summary>
        IDictionary<string, JToken?> Load();

        /// <summary>
        /// Persists the full set of current settings, overwriting whatever was previously stored.
        /// </summary>
        void Save(IDictionary<string, JToken?> values);
    }
}
