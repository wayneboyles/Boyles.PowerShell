using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A rack storage unit within Hudu, representing a physical rack at a location and its capacity.
    /// </summary>
    public sealed class HuduRackStorage
    {
        /// <summary>
        /// The unique identifier of the rack storage.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The identifier of the location that contains the rack storage.
        /// </summary>
        [JsonProperty("location_id")]
        public int? LocationId { get; set; }

        /// <summary>
        /// The display name of the rack storage.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The description of the rack storage.
        /// </summary>
        [JsonProperty("description")]
        public string? Description { get; set; }

        /// <summary>
        /// The maximum power draw, in watts, that the rack storage supports.
        /// </summary>
        [JsonProperty("max_wattage")]
        public int? MaxWattage { get; set; }

        /// <summary>
        /// The number of the first rack unit available in the rack storage.
        /// </summary>
        [JsonProperty("starting_unit")]
        public int? StartingUnit { get; set; }

        /// <summary>
        /// The height of the rack storage, in rack units.
        /// </summary>
        [JsonProperty("height")]
        public int? Height { get; set; }

        /// <summary>
        /// The width of the rack storage.
        /// </summary>
        [JsonProperty("width")]
        public int? Width { get; set; }

        /// <summary>
        /// The UTC timestamp at which the rack storage was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the rack storage was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the rack storage was discarded, or <see langword="null"/> if it has not been.
        /// </summary>
        [JsonProperty("discarded_at")]
        public DateTimeOffset? DiscardedAt { get; set; }

        /// <summary>
        /// The identifier of the company that owns the rack storage.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }
    }
}
