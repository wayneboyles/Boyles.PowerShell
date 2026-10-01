using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A label applied to a specific Hudu record (e.g. an article, asset or website), linking that record to a <see cref="HuduLabelType"/>.
    /// </summary>
    public sealed class HuduLabel
    {
        /// <summary>
        /// The unique identifier of the label.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The identifier of the <see cref="HuduLabelType"/> this label applies.
        /// </summary>
        [JsonProperty("label_type_id")]
        public int? LabelTypeId { get; set; }

        /// <summary>
        /// The type of record the label is applied to. Valid values are Article, Asset, AssetPassword,
        /// Website, IpAddress, Vlan, VlanZone, Procedure, Network and RackStorage.
        /// </summary>
        [JsonProperty("labelable_type")]
        public string? LabelableType { get; set; }

        /// <summary>
        /// The identifier of the record the label is applied to.
        /// </summary>
        [JsonProperty("labelable_id")]
        public int? LabelableId { get; set; }

        /// <summary>
        /// The identifier of the user who applied the label.
        /// </summary>
        [JsonProperty("user_id")]
        public int? UserId { get; set; }

        /// <summary>
        /// The UTC timestamp at which the label was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the label was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }
    }
}
