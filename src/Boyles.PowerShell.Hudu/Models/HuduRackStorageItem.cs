using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// An item placed in a <see cref="HuduRackStorage"/>, occupying a range of rack units,
    /// typically to hold an asset or to reserve space.
    /// </summary>
    public sealed class HuduRackStorageItem
    {
        /// <summary>
        /// The unique identifier of the rack storage item.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The identifier of the rack storage role assigned to the item.
        /// </summary>
        [JsonProperty("rack_storage_role_id")]
        public int? RackStorageRoleId { get; set; }

        /// <summary>
        /// The identifier of the asset housed by the item, or <see langword="null"/> if it holds no asset.
        /// </summary>
        [JsonProperty("asset_id")]
        public int? AssetId { get; set; }

        /// <summary>
        /// The number of the first rack unit the item occupies.
        /// </summary>
        [JsonProperty("start_unit")]
        public int? StartUnit { get; set; }

        /// <summary>
        /// The number of the last rack unit the item occupies.
        /// </summary>
        [JsonProperty("end_unit")]
        public int? EndUnit { get; set; }

        /// <summary>
        /// The numeric code identifying the status of the item.
        /// </summary>
        [JsonProperty("status")]
        public int? Status { get; set; }

        /// <summary>
        /// The numeric code identifying the side of the rack the item is mounted on.
        /// </summary>
        [JsonProperty("side")]
        public int? Side { get; set; }

        /// <summary>
        /// The maximum power draw, in watts, that the item supports.
        /// </summary>
        [JsonProperty("max_wattage")]
        public int? MaxWattage { get; set; }

        /// <summary>
        /// The current power draw of the item, in watts.
        /// </summary>
        [JsonProperty("power_draw")]
        public int? PowerDraw { get; set; }

        /// <summary>
        /// The name of the rack storage role assigned to the item.
        /// </summary>
        [JsonProperty("rack_storage_role_name")]
        public string? RackStorageRoleName { get; set; }

        /// <summary>
        /// The message displayed when the item is reserved.
        /// </summary>
        [JsonProperty("reserved_message")]
        public string? ReservedMessage { get; set; }

        /// <summary>
        /// The description of the rack storage role assigned to the item.
        /// </summary>
        [JsonProperty("rack_storage_role_description")]
        public string? RackStorageRoleDescription { get; set; }

        /// <summary>
        /// The hex colour of the rack storage role assigned to the item.
        /// </summary>
        [JsonProperty("rack_storage_role_hex_color")]
        public string? RackStorageRoleHexColor { get; set; }

        /// <summary>
        /// The name of the asset housed by the item.
        /// </summary>
        [JsonProperty("asset_name")]
        public string? AssetName { get; set; }

        /// <summary>
        /// The URL of the housed asset within the Hudu web interface.
        /// </summary>
        [JsonProperty("asset_url")]
        public string? AssetUrl { get; set; }

        /// <summary>
        /// The URL of the rack storage item within the Hudu web interface.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }

        /// <summary>
        /// The identifier of the company that owns the item.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }
    }
}
