using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A Magic Dash tile, a small dashboard card that surfaces a message and optional link or content
    /// against a Hudu company.
    /// </summary>
    public sealed class HuduMagicDash
    {
        /// <summary>
        /// The unique identifier of the Magic Dash tile.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The title displayed on the tile.
        /// </summary>
        [JsonProperty("title")]
        public string? Title { get; set; }

        /// <summary>
        /// The message displayed on the tile beneath the title.
        /// </summary>
        [JsonProperty("message")]
        public string? Message { get; set; }

        /// <summary>
        /// The colour shade of the tile, which conveys its status.
        /// </summary>
        [JsonProperty("shade")]
        public string? Shade { get; set; }

        /// <summary>
        /// The URL the tile links to when selected.
        /// </summary>
        [JsonProperty("content_link")]
        public string? ContentLink { get; set; }

        /// <summary>
        /// The HTML content shown when the tile is opened.
        /// </summary>
        [JsonProperty("content")]
        public string? Content { get; set; }

        /// <summary>
        /// The name of the icon displayed on the tile.
        /// </summary>
        [JsonProperty("icon")]
        public string? Icon { get; set; }

        /// <summary>
        /// The URL of an image displayed on the tile.
        /// </summary>
        [JsonProperty("image_url")]
        public string? ImageUrl { get; set; }

        /// <summary>
        /// The identifier of the company the tile belongs to.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// The name of the company the tile belongs to.
        /// </summary>
        [JsonProperty("company_name")]
        public string? CompanyName { get; set; }

        /// <summary>
        /// The display position of the tile on the company dashboard.
        /// </summary>
        [JsonProperty("position")]
        public int? Position { get; set; }
    }
}
