using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A category of <see cref="HuduFlag"/>, defining the name and colour shown when a flag of this
    /// type is applied to a record.
    /// </summary>
    public class HuduFlagType
    {
        /// <summary>
        /// The unique identifier of the flag type.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The display name of the flag type.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The colour used to render flags of this type.
        /// </summary>
        [JsonProperty("color")]
        public string? Color { get; set; }

        /// <summary>
        /// The URL-friendly identifier Hudu derives from the name.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug  { get; set; }
    }
}