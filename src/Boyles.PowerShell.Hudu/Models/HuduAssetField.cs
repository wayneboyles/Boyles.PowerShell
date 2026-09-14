using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A populated custom field as returned on an asset by the Hudu read API.
    /// </summary>
    /// <remarks>
    /// This is the read shape only. When writing, Hudu expects a <c>custom_fields</c> array containing a
    /// single object keyed by the snake cased field label; see <see cref="HuduFieldSet"/>.
    /// </remarks>
    public sealed class HuduAssetField {
        /// <summary>
        /// The identifier of the layout field this value belongs to.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The human readable label as configured on the asset layout.
        /// </summary>
        [JsonProperty("label")]
        public string? Label { get; set; }

        /// <summary>
        /// The ordinal position of the field within the asset layout.
        /// </summary>
        [JsonProperty("position")]
        public int? Position { get; set; }

        /// <summary>
        /// The field type, corresponding to one of the constants on <see cref="HuduFieldType"/>.
        /// </summary>
        [JsonProperty("field_type")]
        public string? FieldType { get; set; }

        /// <summary>
        /// The stored value. Scalar for most field types, an array for
        /// <see cref="HuduFieldType.AssetTag"/> and <see cref="HuduFieldType.ListSelect"/>.
        /// </summary>
        [JsonProperty("value")]
        public object? Value { get; set; }

        /// <summary>
        /// Indicates whether the field participates in expiration tracking.
        /// </summary>
        [JsonProperty("expiration")]
        public bool? Expiration { get; set; }

        /// <summary>
        /// The snake cased wire key used when writing this field back to Hudu.
        /// </summary>
        /// <remarks>
        /// Derived from <see cref="Label"/> rather than transmitted by the API.
        /// </remarks>
        [JsonIgnore]
        public string WireKey {
            get { return HuduFieldSet.NormalizeLabel(Label); }
        }

        /// <summary>
        /// Returns the field value rendered as a string, or an empty string when unset.
        /// </summary>
        /// <returns>
        /// The string form of <see cref="Value"/>.
        /// </returns>
        public override string ToString() {
            return Value?.ToString() ?? string.Empty;
        }
    }
}
