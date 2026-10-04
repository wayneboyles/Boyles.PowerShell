using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A photo stored in Hudu, organised into a folder and optionally attached to another record.
    /// </summary>
    public sealed class HuduPhoto
    {
        /// <summary>
        /// The unique identifier of the photo.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The identifier of the company that owns the photo.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// The identifier of the folder that contains the photo.
        /// </summary>
        [JsonProperty("folder_id")]
        public int? FolderId { get; set; }

        /// <summary>
        /// The type of record the photo is attached to, for example <c>Asset</c>.
        /// </summary>
        [JsonProperty("photoable_type")]
        public string? PhotoableType { get; set; }

        /// <summary>
        /// The identifier of the record the photo is attached to.
        /// </summary>
        [JsonProperty("photoable_id")]
        public int? PhotoableId { get; set; }

        /// <summary>
        /// The caption of the photo.
        /// </summary>
        [JsonProperty("caption")]
        public string? Caption { get; set; }

        /// <summary>
        /// Indicates whether the photo is pinned.
        /// </summary>
        [JsonProperty("pinned")]
        public bool? Pinned { get; set; }

        /// <summary>
        /// Indicates whether the photo has been archived.
        /// </summary>
        [JsonProperty("archived")]
        public bool? Archived { get; set; }

        /// <summary>
        /// The UTC timestamp at which the photo was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the photo was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }
    }
}
