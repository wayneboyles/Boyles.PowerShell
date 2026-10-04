using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A website monitored by Hudu, including its uptime, SSL, WHOIS, DNS and email authentication tracking settings.
    /// </summary>
    public sealed class HuduWebsite
    {
        /// <summary>
        /// The unique identifier of the website.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The name of the website, typically its URL or domain.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The most recent status code recorded by the monitor.
        /// </summary>
        [JsonProperty("code")]
        public int? Code { get; set; }

        /// <summary>
        /// The most recent status message recorded by the monitor.
        /// </summary>
        [JsonProperty("message")]
        public string? Message { get; set; }

        /// <summary>
        /// The slug segment used in the website's URL.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }

        /// <summary>
        /// The keyword the monitor looks for in the response when keyword monitoring is in use.
        /// </summary>
        [JsonProperty("keyword")]
        public string? Keyword { get; set; }

        /// <summary>
        /// The numeric code identifying the type of monitor applied to the website.
        /// </summary>
        [JsonProperty("monitor_type")]
        public int? MonitorType { get; set; }

        /// <summary>
        /// The current status of the website.
        /// </summary>
        [JsonProperty("status")]
        public string? Status { get; set; }

        /// <summary>
        /// The current monitoring status of the website.
        /// </summary>
        [JsonProperty("monitoring_status")]
        public string? MonitoringStatus { get; set; }

        /// <summary>
        /// The UTC timestamp at which the website's details were last refreshed.
        /// </summary>
        [JsonProperty("refreshed_at")]
        public DateTimeOffset? RefreshedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the website was last monitored.
        /// </summary>
        [JsonProperty("monitored_at")]
        public DateTimeOffset? MonitoredAt { get; set; }

        /// <summary>
        /// The custom HTTP headers sent with monitoring requests.
        /// </summary>
        [JsonProperty("headers")]
        public Dictionary<string, string> Headers { get; set; } = new();

        /// <summary>
        /// Indicates whether monitoring of the website is paused.
        /// </summary>
        [JsonProperty("paused")]
        public bool? Paused { get; set; }

        /// <summary>
        /// Indicates whether notifications have been sent for the website's current state.
        /// </summary>
        [JsonProperty("sent_notifications")]
        public bool? SentNotifications { get; set; }

        /// <summary>
        /// The identifier of the Hudu account that owns the website.
        /// </summary>
        [JsonProperty("account_id")]
        public int? AccountId { get; set; }

        /// <summary>
        /// The identifier of the asset field the website is linked from, if any.
        /// </summary>
        [JsonProperty("asset_field_id")]
        public int? AssetFieldId { get; set; }

        /// <summary>
        /// The identifier of the company that owns the website.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// The UTC timestamp at which the website was discarded, or <see langword="null"/> if it has not been.
        /// </summary>
        [JsonProperty("discarded_at")]
        public DateTimeOffset? DiscardedAt { get; set; }

        /// <summary>
        /// Indicates whether SSL certificate monitoring is disabled.
        /// </summary>
        [JsonProperty("disable_ssl")]
        public bool? DisableSsl { get; set; }

        /// <summary>
        /// Indicates whether WHOIS monitoring is disabled.
        /// </summary>
        [JsonProperty("disable_whois")]
        public bool? DisableWhois { get; set; }

        /// <summary>
        /// Indicates whether DNS monitoring is disabled.
        /// </summary>
        [JsonProperty("disable_dns")]
        public bool? DisableDns { get; set; }

        /// <summary>
        /// Indicates whether DMARC record tracking is enabled.
        /// </summary>
        [JsonProperty("enable_dmarc_tracking")]
        public bool? EnableDmarcTracking { get; set; }

        /// <summary>
        /// Indicates whether DKIM record tracking is enabled.
        /// </summary>
        [JsonProperty("enable_dkim_tracking")]
        public bool? EnableDkimTracking { get; set; }

        /// <summary>
        /// Indicates whether SPF record tracking is enabled.
        /// </summary>
        [JsonProperty("enable_spf_tracking")]
        public bool? EnableSpfTracking { get; set; }

        /// <summary>
        /// Free-form notes about the website.
        /// </summary>
        [JsonProperty("notes")]
        public string? Notes { get; set; }

        /// <summary>
        /// The type of Hudu object the website represents.
        /// </summary>
        [JsonProperty("object_type")]
        public string? ObjectType { get; set; }

        /// <summary>
        /// The icon displayed alongside the website in the Hudu web interface.
        /// </summary>
        [JsonProperty("icon")]
        public string? Icon { get; set; }

        /// <summary>
        /// The asset type associated with the website.
        /// </summary>
        [JsonProperty("asset_type")]
        public string? AssetType { get; set; }

        /// <summary>
        /// The name of the company that owns the website.
        /// </summary>
        [JsonProperty("company_name")]
        public string? CompanyName { get; set; }

        /// <summary>
        /// Indicates whether the website has been archived.
        /// </summary>
        [JsonProperty("archived")]
        public bool? Archived { get; set; }

        /// <summary>
        /// The URL of the website within the Hudu web interface.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }
    }
}
