using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A single item belonging to a <see cref="HuduList"/>.
    /// </summary>
    public sealed class HuduListItem
    {
        /// <summary>
        /// The unique identifier of the list item.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The display name of the list item.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }
    }
}
