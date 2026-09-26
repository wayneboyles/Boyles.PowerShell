using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A card that links a Hudu record to an entity in an external integration (e.g. a PSA, RMM or Microsoft 365).
    /// </summary>
    public sealed class HuduCard
    {
        /// <summary>
        /// The unique identifier of the card.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The identifier of the integrator that owns the card.
        /// </summary>
        [JsonProperty("integrator_id")]
        public int? IntegratorId { get; set; }

        /// <summary>
        /// The display name of the integrator that owns the card.
        /// </summary>
        [JsonProperty("integrator_name")]
        public string? IntegratorName { get; set; }

        /// <summary>
        /// The URL linking to the entity within the external integration.
        /// </summary>
        [JsonProperty("link")]
        public string? Link { get; set; }

        /// <summary>
        /// The value of the card's primary display field.
        /// </summary>
        [JsonProperty("primary_field")]
        public string? PrimaryField { get; set; }

        /// <summary>
        /// The raw, integration-specific payload associated with the card.
        /// </summary>
        [JsonProperty("data")]
        public JObject? Data { get; set; }

        /// <summary>
        /// The Microsoft 365 products assigned to the linked entity.
        /// </summary>
        [JsonProperty("office_365_assigned_products")]
        public List<string>? Office365AssignedProducts { get; set; }

        /// <summary>
        /// The date the Exchange licence was assigned, as returned by Hudu (e.g. "Oct 13, 2025").
        /// </summary>
        [JsonProperty("exchange_license_assign_date")]
        public string? ExchangeLicenseAssignDate { get; set; }

        /// <summary>
        /// The date the OneDrive licence was assigned, as returned by Hudu (e.g. "Oct 13, 2025").
        /// </summary>
        [JsonProperty("onedrive_license_assign_date")]
        public string? OneDriveLicenseAssignDate { get; set; }

        /// <summary>
        /// The date the SharePoint licence was assigned, as returned by Hudu (e.g. "Oct 13, 2025").
        /// </summary>
        [JsonProperty("sharepoint_license_assign_date")]
        public string? SharePointLicenseAssignDate { get; set; }

        /// <summary>
        /// The date the Skype for Business licence was assigned, as returned by Hudu (e.g. "Oct 13, 2025").
        /// </summary>
        [JsonProperty("skype_for_business_license_assign_date")]
        public string? SkypeForBusinessLicenseAssignDate { get; set; }

        /// <summary>
        /// The type of the Hudu record the card is synced to (e.g. "Asset" or "Company").
        /// </summary>
        [JsonProperty("sync_type")]
        public string? SyncType { get; set; }

        /// <summary>
        /// The numeric identifier of the entity in the external integration.
        /// </summary>
        [JsonProperty("sync_id")]
        public int? SyncId { get; set; }

        /// <summary>
        /// The string identifier of the entity in the external integration.
        /// </summary>
        [JsonProperty("sync_identifier")]
        public string? SyncIdentifier { get; set; }
    }
}
