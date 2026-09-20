namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// Represents a Hudu asset password record. Property names are mapped to the API's
    /// snake_case JSON via the SnakeCaseNamingStrategy configured on HttpClientBase.DefaultJson,
    /// so no explicit [JsonProperty] attributes are required for the standard fields below.
    /// </summary>
    public class HuduAssetPassword
    {
        /// <summary>
        /// The unique identifier of the password record.
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// The ID of the object that owns this password (e.g. an asset or company),
        /// as identified by PasswordableType.
        /// </summary>
        public int PasswordableId { get; set; }

        /// <summary>
        /// The type of the object that owns this password (e.g. "Asset", "Company").
        /// </summary>
        public string? PasswordableType { get; set; }

        /// <summary>
        /// The ID of the company this password belongs to.
        /// </summary>
        public int CompanyId { get; set; }

        /// <summary>
        /// The display name of the password record.
        /// </summary>
        public string? Name { get; set; }

        /// <summary>
        /// The username associated with the password.
        /// </summary>
        public string? Username { get; set; }

        /// <summary>
        /// The URL-friendly slug identifying this password record.
        /// </summary>
        public string? Slug { get; set; }

        /// <summary>
        /// A free-text description of the password record.
        /// </summary>
        public string? Description { get; set; }

        /// <summary>
        /// The password value.
        /// </summary>
        public string? Password { get; set; }

        /// <summary>
        /// The OTP (one-time password) secret used for generating time-based codes, if configured.
        /// </summary>
        public string? OtpSecret { get; set; }

        /// <summary>
        /// The type/category of the password (e.g. "Password", "Embed").
        /// </summary>
        public string? PasswordType { get; set; }

        /// <summary>
        /// The general URL associated with the password record.
        /// </summary>
        public string? Url { get; set; }

        /// <summary>
        /// The UTC timestamp at which the password record was created.
        /// </summary>
        public DateTimeOffset CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the password record was last updated.
        /// </summary>
        public DateTimeOffset UpdatedAt { get; set; }

        /// <summary>
        /// The ID of the password folder containing this record, or <c>null</c> when
        /// the password is not organized into a folder.
        /// </summary>
        public int? PasswordFolderId { get; set; }

        /// <summary>
        /// The name of the password folder containing this record, or <c>null</c> when
        /// the password is not organized into a folder.
        /// </summary>
        public string? PasswordFolderName { get; set; }

        /// <summary>
        /// The login URL used to authenticate with the associated service, if applicable.
        /// </summary>
        public string? LoginUrl { get; set; }
    }
}
