using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// Represents a document/page record (e.g. a knowledge-base article or wiki page)
    /// retrieved from the source API, including sharing and ownership metadata.
    /// </summary>
    public sealed class HuduArticle
    {
        /// <summary>
        /// Unique numeric identifier for the document.
        /// </summary>
        [JsonProperty("id")]
        public int Id { get; set; }

        /// <summary>
        /// URL-friendly identifier derived from the document name.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }

        /// <summary>
        /// Display name/title of the document.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// Indicates whether the document is an unpublished draft.
        /// </summary>
        [JsonProperty("draft")]
        public bool Draft { get; set; }

        /// <summary>
        /// The main body/content of the document (HTML, Markdown, etc., depending on source).
        /// </summary>
        [JsonProperty("content")]
        public string? Content { get; set; }

        /// <summary>
        /// Canonical URL where the document can be viewed.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }

        /// <summary>
        /// The type/category of object this document represents (source uses snake_case: object_type).
        /// </summary>
        [JsonProperty("object_type")]
        public string? ObjectType { get; set; }

        /// <summary>
        /// Identifier of the folder containing this document (source uses snake_case: folder_id).
        /// </summary>
        [JsonProperty("folder_id")]
        public int FolderId { get; set; }

        /// <summary>
        /// Indicates whether external/public sharing is enabled for this document (source uses snake_case: enable_sharing).
        /// </summary>
        [JsonProperty("enable_sharing")]
        public bool EnableSharing { get; set; }

        /// <summary>
        /// Public-facing URL used when sharing is enabled (source uses snake_case: share_url).
        /// </summary>
        [JsonProperty("share_url")]
        public string? ShareUrl { get; set; }

        /// <summary>
        /// Identifier of the company/tenant that owns this document (source uses snake_case: company_id).
        /// </summary>
        [JsonProperty("company_id")]
        public int CompanyId { get; set; }

        /// <summary>
        /// Timestamp of when the document was originally created (source uses snake_case: created_at).
        /// </summary>
        [JsonProperty("created_at")]
        public DateTime CreatedAt { get; set; }

        /// <summary>
        /// Timestamp of the most recent update to the document (source uses snake_case: updated_at).
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTime UpdatedAt { get; set; }

        /// <summary>
        /// Collection of URLs (or paths) to publicly accessible photos associated with the document (source uses snake_case: public_photos).
        /// </summary>
        [JsonProperty("public_photos")]
        public string[] PublicPhotos { get; set; } = [];

    }
}
