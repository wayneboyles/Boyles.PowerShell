using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A VLAN within Hudu, belonging to a company and optionally assigned to a <see cref="HuduVlanZone"/>.
    /// </summary>
    public sealed class HuduVlan
    {
        /// <summary>
        /// The unique identifier of the VLAN record in Hudu.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The display name of the VLAN.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The slug segment used in the VLAN's URL.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }

        /// <summary>
        /// The VLAN ID (the 802.1Q tag number) as configured on the network, distinct from <see cref="Id"/>.
        /// </summary>
        [JsonProperty("vlan_id")]
        public int? VlanId { get; set; }

        /// <summary>
        /// The description of the VLAN.
        /// </summary>
        [JsonProperty("description")]
        public string? Description { get; set; }

        /// <summary>
        /// Free-form notes about the VLAN.
        /// </summary>
        [JsonProperty("notes")]
        public string? Notes { get; set; }

        /// <summary>
        /// The identifier of the company that owns the VLAN.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// The identifier of the VLAN zone the VLAN belongs to, or <see langword="null"/> if it is not in a zone.
        /// </summary>
        [JsonProperty("vlan_zone_id")]
        public int? VlanZoneId { get; set; }

        /// <summary>
        /// The identifier of the list item that represents the VLAN's status.
        /// </summary>
        [JsonProperty("status_list_item_id")]
        public int? StatusListItemId { get; set; }

        /// <summary>
        /// The identifier of the list item that represents the VLAN's role.
        /// </summary>
        [JsonProperty("role_list_item_id")]
        public int? RoleListItemId { get; set; }

        /// <summary>
        /// The UTC timestamp at which the VLAN was archived, or <see langword="null"/> if it is active.
        /// </summary>
        [JsonProperty("archived_at")]
        public DateTimeOffset? ArchivedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the VLAN was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the VLAN was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }

        /// <summary>
        /// The number of networks associated with the VLAN.
        /// </summary>
        [JsonProperty("networks_count")]
        public int? NetworksCount { get; set; }

        /// <summary>
        /// The URL of the VLAN within the Hudu web interface.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }
    }
}
