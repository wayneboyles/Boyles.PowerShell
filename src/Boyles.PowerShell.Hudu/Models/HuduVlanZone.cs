using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A VLAN zone within Hudu, which groups VLANs for a company under a set of permitted VLAN ID ranges.
    /// </summary>
    public sealed class HuduVlanZone
    {
        /// <summary>
        /// The unique identifier of the VLAN zone.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The display name of the VLAN zone.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The slug segment used in the VLAN zone's URL.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }

        /// <summary>
        /// The description of the VLAN zone.
        /// </summary>
        [JsonProperty("description")]
        public string? Description { get; set; }

        /// <summary>
        /// The VLAN ID ranges permitted in the zone, expressed as a delimited string, for example <c>1-100,200-300</c>.
        /// </summary>
        [JsonProperty("vlan_id_ranges")]
        public string? VlanIdRanges { get; set; }

        /// <summary>
        /// The identifier of the company that owns the VLAN zone.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// The UTC timestamp at which the VLAN zone was archived, or <see langword="null"/> if it is active.
        /// </summary>
        [JsonProperty("archived_at")]
        public DateTimeOffset? ArchivedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the VLAN zone was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the VLAN zone was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }

        /// <summary>
        /// The number of VLANs that belong to the zone.
        /// </summary>
        [JsonProperty("vlans_count")]
        public int? VlanCount { get; set; }

        /// <summary>
        /// The URL of the VLAN zone within the Hudu web interface.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }
    }
}
