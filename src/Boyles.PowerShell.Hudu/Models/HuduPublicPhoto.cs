using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A publicly accessible photo stored in Hudu and attached to another record.
    /// </summary>
    public sealed class HuduPublicPhoto
    {
        /// <summary>
        /// The string identifier of the public photo.
        /// </summary>
        [JsonProperty("id")]
        public string? Id { get; set; }

        /// <summary>
        /// The numeric identifier of the public photo.
        /// </summary>
        [JsonProperty("numeric_id")]
        public int? NumericId { get; set; }

        /// <summary>
        /// The URL from which the photo can be retrieved.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }

        /// <summary>
        /// The type of record the photo is attached to.
        /// </summary>
        [JsonProperty("record_type")]
        public string? RecordType { get; set; }

        /// <summary>
        /// The identifier of the record the photo is attached to.
        /// </summary>
        [JsonProperty("record_id")]
        public int? RecordId { get; set; }

        /// <summary>
        /// The file name of the photo.
        /// </summary>
        [JsonProperty("file_name")]
        public string? FileName { get; set; }

        /// <summary>
        /// The size of the photo file, in bytes.
        /// </summary>
        [JsonProperty("file_size")]
        public long? FileSize { get; set; }
    }
}
