using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// An asset layout, which defines the custom field schema shared by every asset of that category.
    /// </summary>
    public sealed class HuduAssetLayout 
    {
        /// <summary>
        /// The unique identifier of the layout.
        /// </summary>
        [JsonProperty("id", NullValueHandling = NullValueHandling.Ignore)]
        public int? Id { get; set; }

        /// <summary>
        /// The display name of the layout.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The name of the icon shown alongside assets of this layout.
        /// </summary>
        [JsonProperty("icon", NullValueHandling = NullValueHandling.Ignore)]
        public string? Icon { get; set; }

        /// <summary>
        /// The background colour of the layout badge, as a hexadecimal string.
        /// </summary>
        [JsonProperty("color", NullValueHandling = NullValueHandling.Ignore)]
        public string? Color { get; set; }

        /// <summary>
        /// The foreground colour of the layout icon, as a hexadecimal string.
        /// </summary>
        [JsonProperty("icon_color", NullValueHandling = NullValueHandling.Ignore)]
        public string? IconColor { get; set; }

        /// <summary>
        /// Indicates whether the layout is available for new assets.
        /// </summary>
        [JsonProperty("active", NullValueHandling = NullValueHandling.Ignore)]
        public bool? Active { get; set; }

        /// <summary>
        /// Indicates whether assets of this layout expose a passwords section.
        /// </summary>
        [JsonProperty("include_passwords", NullValueHandling = NullValueHandling.Ignore)]
        public bool? IncludePasswords { get; set; }

        /// <summary>
        /// Indicates whether assets of this layout expose a photos section.
        /// </summary>
        [JsonProperty("include_photos", NullValueHandling = NullValueHandling.Ignore)]
        public bool? IncludePhotos { get; set; }

        /// <summary>
        /// Indicates whether assets of this layout expose a comments section.
        /// </summary>
        [JsonProperty("include_comments", NullValueHandling = NullValueHandling.Ignore)]
        public bool? IncludeComments { get; set; }

        /// <summary>
        /// Indicates whether assets of this layout expose a files section.
        /// </summary>
        [JsonProperty("include_files", NullValueHandling = NullValueHandling.Ignore)]
        public bool? IncludeFiles { get; set; }

        /// <summary>
        /// The URL slug generated from the layout name.
        /// </summary>
        [JsonProperty("slug", NullValueHandling = NullValueHandling.Ignore)]
        public string? Slug { get; set; }

        /// <summary>
        /// The UTC timestamp at which the layout was created.
        /// </summary>
        [JsonProperty("created_at", NullValueHandling = NullValueHandling.Ignore)]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the layout was last modified.
        /// </summary>
        [JsonProperty("updated_at", NullValueHandling = NullValueHandling.Ignore)]
        public DateTimeOffset? UpdatedAt { get; set; }

        /// <summary>
        /// The field definitions belonging to the layout.
        /// </summary>
        [JsonProperty("fields")]
        public List<HuduAssetLayoutField> Fields { get; set; } = new List<HuduAssetLayoutField>();

        /// <summary>
        /// Retrieves a field definition by label, ignoring case, spacing and punctuation.
        /// </summary>
        /// <param name="label">
        /// The field label, in either human readable or snake cased form.
        /// </param>
        /// <returns>
        /// The matching definition, or <see langword="null"/> when the layout has no such field.
        /// </returns>
        public HuduAssetLayoutField? GetField(string label) {
            string key = HuduFieldSet.NormalizeLabel(label);
            foreach (HuduAssetLayoutField field in Fields) {
                if (string.Equals(field.WireKey, key, StringComparison.Ordinal)) {
                    return field;
                }
            }

            return null;
        }

        /// <summary>
        /// Returns the layout name for diagnostic output.
        /// </summary>
        /// <returns>
        /// The value of <see cref="Name"/>, or an empty string when unset.
        /// </returns>
        public override string ToString() {
            return Name ?? string.Empty;
        }
    }
}
