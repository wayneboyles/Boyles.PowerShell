using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.Settings
{
    /// <summary>
    /// Default <see cref="ISettingsPersistence"/> implementation. Stores settings as a single
    /// JSON object in a per-user file under the platform's application-data folder, so a value set
    /// from one Boyles.PowerShell session (or one sub-module's C# client) is visible to every other
    /// session and module on the same machine without any extra wiring.
    /// </summary>
    public sealed class JsonFileSettingsPersistence : ISettingsPersistence
    {
        /// <summary>
        /// Shared serializer settings: indented for human-readable diffs when the file is opened
        /// directly for troubleshooting.
        /// </summary>
        private static readonly JsonSerializerSettings JsonOptions = new()
        {
            Formatting = Formatting.Indented
        };

        /// <summary>
        /// Full path to the settings.json file this instance reads from and writes to.
        /// </summary>
        public string FilePath { get; }

        /// <summary>
        /// Initializes a new instance pointed at the default per-user settings location, or at
        /// <paramref name="filePath"/> when one is explicitly supplied (primarily for unit tests,
        /// which should never touch the real per-user file).
        /// </summary>
        /// <param name="filePath">Explicit settings file path, or null to use the default location.</param>
        public JsonFileSettingsPersistence(string? filePath = null)
        {
            FilePath = string.IsNullOrWhiteSpace(filePath) ? ResolveDefaultPath() : filePath!;
        }

        /// <summary>
        /// Reads and deserializes the JSON settings file into a dictionary of raw <see cref="JToken"/>
        /// values. Returns an empty dictionary when the file does not exist yet, or when it fails to
        /// parse (e.g. hand-edited into invalid JSON), rather than throwing and breaking every client
        /// that reads settings at startup.
        /// </summary>
        public IDictionary<string, JToken?> Load()
        {
            if (!File.Exists(FilePath))
            {
                return new Dictionary<string, JToken?>(StringComparer.OrdinalIgnoreCase);
            }

            try
            {
                var json = File.ReadAllText(FilePath);
                var root = JsonConvert.DeserializeObject<JObject>(json);
                var result = new Dictionary<string, JToken?>(StringComparer.OrdinalIgnoreCase);

                if (root != null)
                {
                    foreach (var property in root.Properties())
                    {
                        result[property.Name] = property.Value;
                    }
                }

                return result;
            }
            catch (JsonException)
            {
                return new Dictionary<string, JToken?>(StringComparer.OrdinalIgnoreCase);
            }
        }

        /// <summary>
        /// Serializes and writes the full settings dictionary to disk as a single JSON object,
        /// creating the containing directory first when it does not already exist.
        /// </summary>
        public void Save(IDictionary<string, JToken?> values)
        {
            var directory = Path.GetDirectoryName(FilePath);
            if (!string.IsNullOrEmpty(directory))
            {
                Directory.CreateDirectory(directory);
            }

            var root = new JObject();
            foreach (var kvp in values)
            {
                root[kvp.Key] = kvp.Value ?? JValue.CreateNull();
            }

            File.WriteAllText(FilePath, JsonConvert.SerializeObject(root, JsonOptions));
        }

        /// <summary>
        /// Computes the default settings file path: %APPDATA%\Boyles.PowerShell\settings.json on
        /// Windows, or ~/.config/Boyles.PowerShell/settings.json on Linux/macOS, matching the
        /// cross-platform PS 5.1/7+ compatibility the rest of the module targets.
        /// </summary>
        private static string ResolveDefaultPath()
        {
            var appData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData, Environment.SpecialFolderOption.Create);

            if (string.IsNullOrEmpty(appData))
            {
                var home = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
                appData = Path.Combine(home, ".config");
            }

            return Path.Combine(appData, "Boyles.PowerShell", "settings.json");
        }
    }
}
