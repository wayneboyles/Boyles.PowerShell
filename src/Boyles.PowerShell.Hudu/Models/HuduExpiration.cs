using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// An expiration tracked by Hudu, such as a domain, SSL certificate, warranty or asset field date.
    /// </summary>
    public sealed class HuduExpiration
    {
        /// <summary>
        /// The unique identifier of the expiration.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The calendar date on which the item expires.
        /// </summary>
        [JsonProperty("date")]
        public DateTime? Date { get; set; }

        /// <summary>
        /// The type of the record the expiration belongs to (e.g. "Asset", "Website" or "Domain").
        /// </summary>
        [JsonProperty("expirationable_type")]
        public string? ExpirationableType { get; set; }

        /// <summary>
        /// The identifier of the record the expiration belongs to.
        /// </summary>
        [JsonProperty("expirationable_id")]
        public int? ExpirationableId { get; set; }

        /// <summary>
        /// The identifier of the Hudu account that owns the expiration.
        /// </summary>
        [JsonProperty("account_id")]
        public int? AccountId { get; set; }

        /// <summary>
        /// The identifier of the company the expiration belongs to.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// The identifier of the asset layout field that defines the expiration, when it comes from an asset field.
        /// </summary>
        [JsonProperty("asset_layout_field_id")]
        public int? AssetLayoutFieldId { get; set; }

        /// <summary>
        /// The identifier of the entity in the external integration the expiration was synced from.
        /// </summary>
        [JsonProperty("sync_id")]
        public int? SyncId { get; set; }

        /// <summary>
        /// The UTC timestamp at which the expiration was archived, or <see langword="null"/> when it is active.
        /// </summary>
        [JsonProperty("archived_at")]
        public DateTimeOffset? ArchivedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the expiration was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the expiration was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }

        /// <summary>
        /// The category of the expiration (e.g. "undeclared", "domain", "ssl_certificate", "warranty" or "asset_field").
        /// </summary>
        [JsonProperty("expiration_type")]
        public string? ExpirationType { get; set; }

        /// <summary>
        /// The identifier of the asset field holding the expiration date, when it comes from an asset field.
        /// </summary>
        [JsonProperty("asset_field_id")]
        public int? AssetFieldId { get; set; }
    }
}
