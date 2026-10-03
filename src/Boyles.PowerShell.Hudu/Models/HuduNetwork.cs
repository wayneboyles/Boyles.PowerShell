using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// Represents a network record in Hudu, such as a subnet or VLAN-backed network
    /// documented for a company.
    /// </summary>
    public class HuduNetwork
    {
        /// <summary>
        /// The unique Hudu identifier of the network.
        /// </summary>
        [JsonProperty("id")]
        public int Id { get; set; }
 
        /// <summary>
        /// The display name of the network.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }
 
        /// <summary>
        /// The network address, typically in CIDR notation (for example, 192.168.1.0/24).
        /// </summary>
        [JsonProperty("address")]
        public string? Address { get; set; }
 
        /// <summary>
        /// The numeric network type as defined by Hudu.
        /// </summary>
        [JsonProperty("network_type")]
        public int? NetworkType { get; set; }
 
        /// <summary>
        /// The URL-friendly identifier of the network.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }
 
        /// <summary>
        /// The identifier of the company that owns the network.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }
 
        /// <summary>
        /// The identifier of the location the network is associated with.
        /// </summary>
        [JsonProperty("location_id")]
        public int? LocationId { get; set; }
 
        /// <summary>
        /// A short description of the network.
        /// </summary>
        [JsonProperty("description")]
        public string? Description { get; set; }
 
        /// <summary>
        /// Free-form notes about the network.
        /// </summary>
        [JsonProperty("notes")]
        public string? Notes { get; set; }
 
        /// <summary>
        /// The hierarchy path used by Hudu to track the parent networks of this network.
        /// </summary>
        [JsonProperty("ancestry")]
        public string? Ancestry { get; set; }
 
        /// <summary>
        /// Additional network settings as returned by Hudu. The structure is not fixed,
        /// so values are kept as raw JSON elements.
        /// </summary>
        [JsonProperty("settings")]
        public Dictionary<string, object>? Settings { get; set; }
 
        /// <summary>
        /// The identifier used to match this network to a record in an external system
        /// during synchronization.
        /// </summary>
        [JsonProperty("sync_identifier")]
        public string? SyncIdentifier { get; set; }
 
        /// <summary>
        /// Indicates whether the network is tracked by Hudu Radar.
        /// </summary>
        [JsonProperty("is_radar")]
        public bool IsRadar { get; set; }
 
        /// <summary>
        /// The identifier of the list item that represents the network's status.
        /// </summary>
        [JsonProperty("status_list_item_id")]
        public int? StatusListItemId { get; set; }
 
        /// <summary>
        /// The identifier of the list item that represents the network's role.
        /// </summary>
        [JsonProperty("role_list_item_id")]
        public int? RoleListItemId { get; set; }
 
        /// <summary>
        /// The identifier of the VLAN associated with the network.
        /// </summary>
        [JsonProperty("vlan_id")]
        public int? VlanId { get; set; }
 
        /// <summary>
        /// The date and time the network record was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }
 
        /// <summary>
        /// The date and time the network record was last updated.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }
 
        /// <summary>
        /// The URL of the network record in the Hudu web interface.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }
 
        /// <summary>
        /// The date and time the network was archived, or <c>null</c> if it is not archived.
        /// </summary>
        [JsonProperty("archived_at")]
        public DateTimeOffset? ArchivedAt { get; set; }
    }
}