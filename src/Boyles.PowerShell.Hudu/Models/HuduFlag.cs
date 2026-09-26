using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A flag applied to a Hudu record (e.g. an asset, company or article), categorized by a <see cref="HuduFlagType"/>.
    /// </summary>
    public sealed class HuduFlag
    {
        /// <summary>
        /// The unique identifier of the flag.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The identifier of the <see cref="HuduFlagType"/> that categorises the flag.
        /// </summary>
        [JsonProperty("flag_type_id")]
        public int? FlagTypeId { get; set; }

        /// <summary>
        /// The free-text description attached to the flag.
        /// </summary>
        [JsonProperty("description")]
        public string? Description { get; set; }

        /// <summary>
        /// The type of the record the flag is applied to (e.g. "Asset", "Company" or "Article").
        /// </summary>
        [JsonProperty("flagable_type")]
        public string? FlagableType { get; set; }

        /// <summary>
        /// The identifier of the record the flag is applied to.
        /// </summary>
        [JsonProperty("flagable_id")]
        public int? FlagableId { get; set; }

        /// <summary>
        /// The UTC timestamp at which the flag was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the flag was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }
    }
}