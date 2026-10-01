using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A single entry from Hudu's audit trail, recording an action a user (or API key) performed
    /// on a record, along with the client it was performed from.
    /// </summary>
    public sealed class HuduActivityLog
    {
        /// <summary>
        /// The unique identifier of the log entry.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// Action-specific detail, such as the fields that changed. Its shape varies by action.
        /// </summary>
        [JsonProperty("details")]
        public object? Details { get; set; }

        /// <summary>
        /// The action performed, e.g. "created", "updated", "viewed" or "deleted".
        /// </summary>
        [JsonProperty("action")]
        public string? Action { get; set; }

        /// <summary>
        /// The IP address the action was performed from.
        /// </summary>
        [JsonProperty("ip_address")]
        public string? IpAddress { get; set; }

        /// <summary>
        /// The API token involved when the action was performed through the API.
        /// </summary>
        [JsonProperty("token")]
        public string? Token { get; set; }

        /// <summary>
        /// The identifier of the user who performed the action.
        /// </summary>
        [JsonProperty("user_id")]
        public int? UserId { get; set; }

        /// <summary>
        /// The email address of the user who performed the action.
        /// </summary>
        [JsonProperty("user_email")]
        public string? UserEmail { get; set; }

        /// <summary>
        /// The record's name at the time of the action, preserved even if it was later renamed or deleted.
        /// </summary>
        [JsonProperty("original_record_name")]
        public string? OriginalRecordName { get; set; }

        /// <summary>
        /// The full name of the user who performed the action.
        /// </summary>
        [JsonProperty("user_name")]
        public string? UserName { get; set; }

        /// <summary>
        /// The abbreviated name of the user who performed the action.
        /// </summary>
        [JsonProperty("user_short_name")]
        public string? UserShortName { get; set; }

        /// <summary>
        /// The type of record acted on, e.g. "Asset", "Company" or "Article".
        /// </summary>
        [JsonProperty("record_type")]
        public string? RecordType { get; set; }

        /// <summary>
        /// The name of the company the record belongs to, if any.
        /// </summary>
        [JsonProperty("company_name")]
        public string? CompanyName { get; set; }

        /// <summary>
        /// The URL of the company the record belongs to.
        /// </summary>
        [JsonProperty("record_company_url")]
        public string? RecordCompanyUrl { get; set; }

        /// <summary>
        /// The URL of the user who performed the action.
        /// </summary>
        [JsonProperty("record_user_url")]
        public string? RecordUserUrl { get; set; }

        /// <summary>
        /// The kind of client the action came from, e.g. the web app or the API.
        /// </summary>
        [JsonProperty("app_type")]
        public string? AppType { get; set; }

        /// <summary>
        /// The identifier of the record acted on.
        /// </summary>
        [JsonProperty("record_id")]
        public int? RecordId { get; set; }

        /// <summary>
        /// The current name of the record acted on.
        /// </summary>
        [JsonProperty("record_name")]
        public string? RecordName { get; set; }

        /// <summary>
        /// The URL of the record acted on.
        /// </summary>
        [JsonProperty("record_url")]
        public string? RecordUrl { get; set; }

        /// <summary>
        /// When the action occurred.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTime? CreatedAt { get; set; }

        /// <summary>
        /// <see cref="CreatedAt"/> pre-formatted by Hudu for display.
        /// </summary>
        [JsonProperty("formatted_datetime")]
        public string? FormattedDatetime { get; set; }

        /// <summary>
        /// The initials of the user who performed the action.
        /// </summary>
        [JsonProperty("user_initials")]
        public string? UserInitials { get; set; }

        /// <summary>
        /// The URL of this log entry.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }

        /// <summary>
        /// The raw User-Agent string of the client the action came from.
        /// </summary>
        [JsonProperty("agent_string")]
        public string? AgentString { get; set; }

        /// <summary>
        /// The device type parsed from <see cref="AgentString"/>.
        /// </summary>
        [JsonProperty("device")]
        public string? Device { get; set; }

        /// <summary>
        /// The operating system parsed from <see cref="AgentString"/>.
        /// </summary>
        [JsonProperty("os")]
        public string? Os { get; set; }
    }
}
