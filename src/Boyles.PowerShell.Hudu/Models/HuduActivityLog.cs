using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    public sealed class HuduActivityLog
    {
        [JsonProperty("id")]
        public int? Id { get; set; }

        [JsonProperty("details")]
        public object? Details { get; set; }

        [JsonProperty("action")]
        public string? Action { get; set; }

        [JsonProperty("ip_address")]
        public string? IpAddress { get; set; }

        [JsonProperty("token")]
        public string? Token { get; set; }

        [JsonProperty("user_id")]
        public int? UserId { get; set; }

        [JsonProperty("user_email")]
        public string? UserEmail { get; set; }

        [JsonProperty("original_record_name")]
        public string? OriginalRecordName { get; set; }

        [JsonProperty("user_name")]
        public string? UserName { get; set; }

        [JsonProperty("user_short_name")]
        public string? UserShortName { get; set; }

        [JsonProperty("record_type")]
        public string? RecordType { get; set; }

        [JsonProperty("company_name")]
        public string? CompanyName { get; set; }

        [JsonProperty("record_company_url")]
        public string? RecordCompanyUrl { get; set; }

        [JsonProperty("record_user_url")]
        public string? RecordUserUrl { get; set; }

        [JsonProperty("app_type")]
        public string? AppType { get; set; }

        [JsonProperty("record_id")]
        public int? RecordId { get; set; }

        [JsonProperty("record_name")]
        public string? RecordName { get; set; }

        [JsonProperty("record_url")]
        public string? RecordUrl { get; set; }

        [JsonProperty("created_at")]
        public DateTime? CreatedAt { get; set; }

        [JsonProperty("formatted_datetime")]
        public string? FormattedDatetime { get; set; }

        [JsonProperty("user_initials")]
        public string? UserInitials { get; set; }

        [JsonProperty("url")]
        public string? Url { get; set; }

        [JsonProperty("agent_string")]
        public string? AgentString { get; set; }

        [JsonProperty("device")]
        public string? Device { get; set; }

        [JsonProperty("os")]
        public string? Os { get; set; }
    }
}
