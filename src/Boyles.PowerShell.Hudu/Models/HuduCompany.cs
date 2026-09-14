using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// Represents a company record returned by the Hudu API.
    /// </summary>
    public sealed class HuduCompany
    {
        /// <summary>
        /// The unique identifier for the company.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The URL-friendly slug for the company.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }

        /// <summary>
        /// The display name of the company.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// An optional informal or abbreviated name for the company.
        /// </summary>
        [JsonProperty("nickname")]
        public string? Nickname { get; set; }

        /// <summary>
        /// The first line of the company's street address.
        /// </summary>
        [JsonProperty("address_line_1")]
        public string? AddressLine1 { get; set; }

        /// <summary>
        /// The second line of the company's street address (suite, floor, etc.).
        /// </summary>
        [JsonProperty("address_line_2")]
        public string? AddressLine2 { get; set; }

        /// <summary>
        /// The city portion of the company's address.
        /// </summary>
        [JsonProperty("city")]
        public string? City { get; set; }

        /// <summary>
        /// The state or province portion of the company's address.
        /// </summary>
        [JsonProperty("state")]
        public string? State { get; set; }

        /// <summary>
        /// The postal or ZIP code portion of the company's address.
        /// </summary>
        [JsonProperty("zip")]
        public string? Zip { get; set; }

        /// <summary>
        /// The full name of the country associated with the company's address.
        /// </summary>
        [JsonProperty("country_name")]
        public string? CountryName { get; set; }

        /// <summary>
        /// The primary phone number for the company.
        /// </summary>
        [JsonProperty("phone_number")]
        public string? PhoneNumber { get; set; }

        /// <summary>
        /// The type or category of the company (e.g., MSP, client, vendor).
        /// </summary>
        [JsonProperty("company_type")]
        public string? CompanyType { get; set; }

        /// <summary>
        /// The identifier of the parent company, if this company is a child entity.
        /// </summary>
        [JsonProperty("parent_company_id")]
        public int? ParentCompanyId { get; set; }

        /// <summary>
        /// The display name of the parent company, if applicable.
        /// </summary>
        [JsonProperty("parent_company_name")]
        public string? ParentCompanyName { get; set; }

        /// <summary>
        /// The fax number for the company.
        /// </summary>
        [JsonProperty("fax_number")]
        public string? FaxNumber { get; set; }

        /// <summary>
        /// The public-facing website URL for the company.
        /// </summary>
        [JsonProperty("website")]
        public string? Website { get; set; }

        /// <summary>
        /// Free-form notes or additional information about the company.
        /// </summary>
        [JsonProperty("notes")]
        public string? Notes { get; set; }

        /// <summary>
        /// Indicates whether the company has been archived and is no longer active.
        /// </summary>
        [JsonProperty("archived")]
        public bool? Archived { get; set; }

        /// <summary>
        /// The Hudu object type discriminator for this record.
        /// </summary>
        [JsonProperty("object_type")]
        public string? ObjectType { get; set; }

        /// <summary>
        /// An external or internal identification number for the company.
        /// </summary>
        [JsonProperty("id_number")]
        public string? IdNumber { get; set; }

        /// <summary>
        /// The relative URL path to the company record within Hudu.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }

        /// <summary>
        /// The fully-qualified URL to the company record within Hudu.
        /// </summary>
        [JsonProperty("full_url")]
        public string? FullUrl { get; set; }

        /// <summary>
        /// The URL to the passwords section for this company in Hudu.
        /// </summary>
        [JsonProperty("passwords_url")]
        public string? PasswordsUrl { get; set; }

        /// <summary>
        /// The URL to the knowledge base section for this company in Hudu.
        /// </summary>
        [JsonProperty("knowledge_base_url")]
        public string? KnowledgeBaseUrl { get; set; }

        /// <summary>
        /// The UTC date and time when this company record was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC date and time when this company record was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }

        /// <summary>
        /// The collection of third-party integrations linked to this company.
        /// </summary>
        [JsonProperty("integrations")]
        public List<HuduCompanyIntegration>? Integrations { get; set; }
    }

    /// <summary>
    /// Represents a single third-party integration record associated with a Hudu company.
    /// </summary>
    public sealed class HuduCompanyIntegration
    {
        /// <summary>
        /// The unique identifier for this integration record.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The identifier of the integrator (i.e., the integration platform or connector).
        /// </summary>
        [JsonProperty("integrator_id")]
        public int? IntegratorId { get; set; }

        /// <summary>
        /// The display name of the integrator platform.
        /// </summary>
        [JsonProperty("integrator_name")]
        public string? IntegratorName { get; set; }

        /// <summary>
        /// The identifier used to track the synchronisation state for this integration.
        /// </summary>
        [JsonProperty("sync_id")]
        public int? SyncId { get; set; }

        /// <summary>
        /// The external identifier that uniquely identifies this company within the integrated system.
        /// </summary>
        [JsonProperty("identifier")]
        public string? Identifier { get; set; }

        /// <summary>
        /// The name of the company as it appears in the integrated system.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The identifier of a potential Hudu company match suggested by the integration.
        /// </summary>
        [JsonProperty("potential_company_id")]
        public int? PotentialCompanyId { get; set; }

        /// <summary>
        /// The identifier of the Hudu company this integration is confirmed to be linked to.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// The name of the Hudu company this integration is confirmed to be linked to.
        /// </summary>
        [JsonProperty("company_name")]
        public string? CompanyName { get; set; }
    }
}
