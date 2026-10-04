using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A Hudu user account, including its sign-in activity and security settings.
    /// </summary>
    public sealed class HuduUser
    {
        /// <summary>
        /// The unique identifier of the user.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The email address of the user.
        /// </summary>
        [JsonProperty("email")]
        public string? Email { get; set; }

        /// <summary>
        /// Indicates whether the user must supply a one-time password (two-factor authentication) to sign in.
        /// </summary>
        [JsonProperty("otp_required_for_login")]
        public bool? OtpRequiredForLogin { get; set; }

        /// <summary>
        /// The security level (role) assigned to the user.
        /// </summary>
        [JsonProperty("security_level")]
        public string? SecurityLevel { get; set; }

        /// <summary>
        /// The first name of the user.
        /// </summary>
        [JsonProperty("first_name")]
        public string? FirstName { get; set; }

        /// <summary>
        /// The last name of the user.
        /// </summary>
        [JsonProperty("last_name")]
        public string? LastName { get; set; }

        /// <summary>
        /// The phone number of the user.
        /// </summary>
        [JsonProperty("phone_number")]
        public string? PhoneNumber { get; set; }

        /// <summary>
        /// The slug segment used in the user's URL.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }

        /// <summary>
        /// The time zone configured for the user.
        /// </summary>
        [JsonProperty("time_zone")]
        public string? TimeZone { get; set; }

        /// <summary>
        /// Indicates whether the user has accepted their invitation to Hudu.
        /// </summary>
        [JsonProperty("accepted_invite")]
        public bool? AcceptedInvite { get; set; }

        /// <summary>
        /// The number of times the user has signed in.
        /// </summary>
        [JsonProperty("sign_in_count")]
        public int? SignInCount { get; set; }

        /// <summary>
        /// Indicates whether the user is currently signed in.
        /// </summary>
        [JsonProperty("currently_signed_in")]
        public bool? CurrentlySignedIn { get; set; }

        /// <summary>
        /// The UTC timestamp of the user's most recent sign-in.
        /// </summary>
        [JsonProperty("last_sign_in_at")]
        public DateTimeOffset? LastSignInAt { get; set; }

        /// <summary>
        /// The IP address from which the user most recently signed in.
        /// </summary>
        [JsonProperty("last_sign_in_ip")]
        public string? LastSignInIp { get; set; }

        /// <summary>
        /// The UTC timestamp at which the user was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the user was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }

        /// <summary>
        /// Indicates whether the user has been archived.
        /// </summary>
        [JsonProperty("archived")]
        public bool? Archived { get; set; }

        /// <summary>
        /// The identifier of the company the user is a portal member of, or <see langword="null"/>
        /// for a regular user.
        /// </summary>
        [JsonProperty("portal_member_company_id")]
        public int? PortalMemberCompanyId { get; set; }

        /// <summary>
        /// The user's activity score over the last 30 days.
        /// </summary>
        [JsonProperty("score_30_days")]
        public int? Score30Days { get; set; }

        /// <summary>
        /// The user's activity score over the last 90 days.
        /// </summary>
        [JsonProperty("score_90_days")]
        public int? Score90Days { get; set; }

        /// <summary>
        /// The user's activity score across all time.
        /// </summary>
        [JsonProperty("score_all_time")]
        public int? ScoreAllTime { get; set; }
    }
}
