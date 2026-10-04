using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A relationship between two Hudu records, such as an asset linked to a company or an article.
    /// </summary>
    public sealed class HuduRelation
    {
        /// <summary>
        /// The unique identifier of the relation.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The description of the relation.
        /// </summary>
        [JsonProperty("description")]
        public string? Description { get; set; }

        /// <summary>
        /// Indicates whether the relation is presented from the inverse side, that is, as seen from the target record.
        /// </summary>
        [JsonProperty("is_inverse")]
        public bool? IsInverse { get; set; }

        /// <summary>
        /// The name of the relation.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The identifier of the record the relation originates from.
        /// </summary>
        [JsonProperty("fromable_id")]
        public int? FromableId { get; set; }

        /// <summary>
        /// The type of record the relation originates from, for example <c>Asset</c>.
        /// </summary>
        [JsonProperty("fromable_type")]
        public string? FromableType { get; set; }

        /// <summary>
        /// The URL of the originating record within the Hudu web interface.
        /// </summary>
        [JsonProperty("fromable_url")]
        public string? FromableUrl { get; set; }

        /// <summary>
        /// The identifier of the record the relation points to.
        /// </summary>
        [JsonProperty("toable_id")]
        public int? ToableId { get; set; }

        /// <summary>
        /// The type of record the relation points to, for example <c>Company</c>.
        /// </summary>
        [JsonProperty("toable_type")]
        public string? ToableType { get; set; }

        /// <summary>
        /// The URL of the target record within the Hudu web interface.
        /// </summary>
        [JsonProperty("toable_url")]
        public string? ToableUrl { get; set; }

        /// <summary>
        /// The UTC timestamp at which the relation was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the relation was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }
    }
}
