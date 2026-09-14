using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// An asset stored within a Hudu company and asset layout.
    /// </summary>
    public sealed class HuduAsset
    {
        /// <summary>
        /// The unique identifier of the asset.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The display name of the asset.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The identifier of the owning company.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// The name of the owning company.
        /// </summary>
        [JsonProperty("company_name")]
        public string? CompanyName { get; set; }

        /// <summary>
        /// The identifier of the asset layout that defines this asset's custom fields.
        /// </summary>
        [JsonProperty("asset_layout_id")]
        public int? AssetLayoutId { get; set; }

        /// <summary>
        /// The relative URL of the asset within the Hudu web interface.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }

        /// <summary>
        /// The slug segment used in the asset's public URL.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }

        /// <summary>
        /// Indicates whether the asset has been archived.
        /// </summary>
        [JsonProperty("archived")]
        public bool? Archived { get; set; }

        /// <summary>
        /// The identifier of the primary serial number field, when configured.
        /// </summary>
        [JsonProperty("primary_serial")]
        public string? PrimarySerial { get; set; }

        /// <summary>
        /// The value of the layout's designated primary model field.
        /// </summary>
        [JsonProperty("primary_model")]
        public string? PrimaryModel { get; set; }

        /// <summary>
        /// The value of the layout's designated primary manufacturer field.
        /// </summary>
        [JsonProperty("primary_manufacturer")]
        public string? PrimaryManufacturer { get; set; }

        /// <summary>
        /// The UTC timestamp at which the asset was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the asset was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }

        /// <summary>
        /// The populated custom fields belonging to the asset's custom card.
        /// </summary>
        [JsonProperty("fields")]
        public List<HuduAssetField> Fields { get; set; } = new List<HuduAssetField>();

        /// <summary>
        /// Retrieves a single custom field by label, ignoring case, spacing and punctuation.
        /// </summary>
        /// <param name="label">
        /// The field label, in either human readable or snake cased form.
        /// </param>
        /// <returns>
        /// The matching field, or <see langword="null"/> when the layout has no such field.
        /// </returns>
        public HuduAssetField? GetField(string label) {
            string key = HuduFieldSet.NormalizeLabel(label);
            foreach (HuduAssetField field in Fields) {
                if (string.Equals(field.WireKey, key, StringComparison.Ordinal)) {
                    return field;
                }
            }

            return null;
        }

        /// <summary>
        /// Retrieves the value of a single custom field by label.
        /// </summary>
        /// <param name="label">
        /// The field label, in either human readable or snake cased form.
        /// </param>
        /// <returns>
        /// The stored value, or <see langword="null"/> when the field is absent or empty.
        /// </returns>
        public object? GetFieldValue(string label) {
            return GetField(label)?.Value;
        }

        /// <summary>
        /// Produces a writable field set seeded with this asset's current field values.
        /// </summary>
        /// <returns>
        /// A new <see cref="HuduFieldSet"/> suitable for mutation and submission back to Hudu.
        /// </returns>
        public HuduFieldSet ToFieldSet() {
            return HuduFieldSet.FromAsset(this);
        }
    }
}
