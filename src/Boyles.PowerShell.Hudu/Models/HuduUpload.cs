using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A file uploaded to Hudu and attached to another record, such as an asset, article or company.
    /// </summary>
    public sealed class HuduUpload
    {
        /// <summary>
        /// The unique identifier of the upload.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The URL from which the uploaded file can be retrieved.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }

        /// <summary>
        /// The file name of the upload.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The file extension of the upload.
        /// </summary>
        [JsonProperty("ext")]
        public string? Ext { get; set; }

        /// <summary>
        /// The MIME type of the upload.
        /// </summary>
        [JsonProperty("mime")]
        public string? Mime { get; set; }

        /// <summary>
        /// The size of the upload, as reported by the Hudu API.
        /// </summary>
        [JsonProperty("size")]
        public string? Size { get; set; }

        /// <summary>
        /// The UTC timestamp at which the upload was created.
        /// </summary>
        [JsonProperty("created_date")]
        public DateTimeOffset? CreatedDate { get; set; }

        /// <summary>
        /// The UTC timestamp at which the upload was archived, or <see langword="null"/> if it is active.
        /// </summary>
        [JsonProperty("archived_at")]
        public DateTimeOffset? ArchivedAt { get; set; }

        /// <summary>
        /// The identifier of the record the upload is attached to.
        /// </summary>
        [JsonProperty("uploadable_id")]
        public int? UploadableId { get; set; }

        /// <summary>
        /// The type of record the upload is attached to, for example <c>Asset</c> or <c>Company</c>.
        /// </summary>
        [JsonProperty("uploadable_type")]
        public string? UploadableType { get; set; }
    }
}
