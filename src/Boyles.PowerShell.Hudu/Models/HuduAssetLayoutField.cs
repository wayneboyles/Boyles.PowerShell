using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A field definition belonging to a Hudu asset layout.
    /// </summary>
    /// <remarks>
    /// This type is used for both reads and writes. Use <see cref="HuduLayoutFieldSet"/> to compose a
    /// collection of these fluently when creating or amending a layout.
    /// </remarks>
    public sealed class HuduAssetLayoutField {
        /// <summary>
        /// The unique identifier of the field. Omitted when creating a new field.
        /// </summary>
        [JsonProperty("id", NullValueHandling = NullValueHandling.Ignore)]
        public int? Id { get; set; }

        /// <summary>
        /// The human readable label displayed in the Hudu interface.
        /// </summary>
        [JsonProperty("label")]
        public string? Label { get; set; }

        /// <summary>
        /// The field type, corresponding to one of the constants on <see cref="HuduFieldType"/>.
        /// </summary>
        [JsonProperty("field_type")]
        public string? FieldType { get; set; }

        /// <summary>
        /// The ordinal position of the field within the layout.
        /// </summary>
        [JsonProperty("position")]
        public int Position { get; set; } = 0;

        /// <summary>
        /// Indicates whether the field must be populated before an asset can be saved.
        /// </summary>
        [JsonProperty("required")]
        public bool? Required { get; set; }

        /// <summary>
        /// Indicates whether the field appears as a column in asset list views.
        /// </summary>
        [JsonProperty("show_in_list")]
        public bool? ShowInList { get; set; }

        /// <summary>
        /// Helper text displayed beneath the field in the editor.
        /// </summary>
        [JsonProperty("hint", NullValueHandling = NullValueHandling.Ignore)]
        public string? Hint { get; set; }

        /// <summary>
        /// The minimum accepted value, applicable to numeric fields.
        /// </summary>
        [JsonProperty("min", NullValueHandling = NullValueHandling.Ignore)]
        public int? Min { get; set; }

        /// <summary>
        /// The maximum accepted value, applicable to numeric fields.
        /// </summary>
        [JsonProperty("max", NullValueHandling = NullValueHandling.Ignore)]
        public int? Max { get; set; }

        /// <summary>
        /// Indicates whether values in this field feed Hudu's expiration tracking.
        /// </summary>
        [JsonProperty("expiration", NullValueHandling = NullValueHandling.Ignore)]
        public bool? Expiration { get; set; }

        /// <summary>
        /// The identifier of the asset layout that an <see cref="HuduFieldType.AssetTag"/> field links to.
        /// </summary>
        [JsonProperty("linkable_id", NullValueHandling = NullValueHandling.Ignore)]
        public int? LinkableId { get; set; }

        /// <summary>
        /// The selectable options for dropdown and multi select fields, newline delimited.
        /// </summary>
        /// <remarks>
        /// Hudu transmits options as a single newline separated string rather than an array. Use
        /// <see cref="HuduLayoutFieldSet.AddDropdown"/> to avoid constructing this by hand.
        /// </remarks>
        [JsonProperty("options", NullValueHandling = NullValueHandling.Ignore)]
        public string? Options { get; set; }

        /// <summary>
        /// The snake cased wire key used when writing values for this field onto an asset.
        /// </summary>
        [JsonIgnore]
        public string WireKey {
            get { return HuduFieldSet.NormalizeLabel(Label); }
        }

        /// <summary>
        /// Returns the field label for diagnostic output.
        /// </summary>
        /// <returns>
        /// The value of <see cref="Label"/>, or an empty string when unset.
        /// </returns>
        public override string ToString() {
            return Label ?? string.Empty;
        }
    }
}
