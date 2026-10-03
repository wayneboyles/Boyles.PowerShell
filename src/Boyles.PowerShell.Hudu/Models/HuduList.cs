using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A Hudu list, a reusable set of named items that can be referenced by list select fields on
    /// asset layouts.
    /// </summary>
    public sealed class HuduList
    {
        /// <summary>
        /// The unique identifier of the list.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The display name of the list.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The UTC timestamp at which the list was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the list was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }

        /// <summary>
        /// The items that belong to the list.
        /// </summary>
        [JsonProperty("list_items")]
        public List<HuduListItem> ListItems { get; set; } = new List<HuduListItem>();
    }
}
