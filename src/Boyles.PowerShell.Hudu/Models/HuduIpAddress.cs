using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// An IP address record tracked within Hudu's IPAM, optionally linked to a company, network and asset.
    /// </summary>
    public sealed class HuduIpAddress
    {
        /// <summary>
        /// The unique identifier of the IP address record.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The IP address.
        /// </summary>
        [JsonProperty("address")]
        public string? Address { get; set; }

        /// <summary>
        /// The status of the IP address. One of <c>unassigned</c>, <c>assigned</c>, <c>reserved</c>,
        /// <c>deprecated</c>, <c>dhcp</c> or <c>slaac</c>.
        /// </summary>
        [JsonProperty("status")]
        public string? Status { get; set; }

        /// <summary>
        /// The fully qualified domain name associated with the IP address.
        /// </summary>
        [JsonProperty("fqdn")]
        public string? Fqdn { get; set; }

        /// <summary>
        /// A brief description of the IP address.
        /// </summary>
        [JsonProperty("description")]
        public string? Description { get; set; }

        /// <summary>
        /// Additional comments about the IP address.
        /// </summary>
        [JsonProperty("notes")]
        public string? Notes { get; set; }

        /// <summary>
        /// The identifier of the asset associated with this IP address.
        /// </summary>
        [JsonProperty("asset_id")]
        public int? AssetId { get; set; }

        /// <summary>
        /// The identifier of the network to which this IP address belongs.
        /// </summary>
        [JsonProperty("network_id")]
        public int? NetworkId { get; set; }

        /// <summary>
        /// The identifier of the company that owns this IP address.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// When <see langword="true"/>, Hudu will not verify that the FQDN resolves to the address when the
        /// record is created or updated. Use this for internal-only hostnames.
        /// </summary>
        [JsonProperty("skip_dns_validation")]
        public bool? SkipDnsValidation { get; set; }
    }
}
