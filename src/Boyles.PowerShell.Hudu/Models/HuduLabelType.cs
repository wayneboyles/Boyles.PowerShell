using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A label type that defines a reusable, colored label which can be applied to supported Hudu records
    /// (e.g. articles, assets, passwords, websites), optionally restricted to specific companies.
    /// </summary>
    public sealed class HuduLabelType
    {
        /// <summary>
        /// The unique identifier of the label type.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The display name of the label type. Must be unique.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The hex color value of the label type (e.g. #0000ff). Accepts 3- or 6-digit hex.
        /// </summary>
        [JsonProperty("color")]
        public string? Color { get; set; }

        /// <summary>
        /// The URL-friendly identifier derived from the label type name.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }

        /// <summary>
        /// The record types this label type may be applied to. Valid values are Article, Asset, AssetPassword,
        /// Website, IpAddress, Vlan, VlanZone, Procedure, Network and RackStorage.
        /// </summary>
        [JsonProperty("applicable_record_types")]
        public List<string> ApplicableRecordTypes { get; set; } = new();

        /// <summary>
        /// The availability scope of the label type. Either all_companies or specific_companies.
        /// </summary>
        [JsonProperty("access_level")]
        public string? AccessLevel { get; set; }

        /// <summary>
        /// The company IDs the label type is restricted to. Only applies when <see cref="AccessLevel"/> is specific_companies.
        /// </summary>
        [JsonProperty("allowed_company_ids")]
        public List<int> AllowedCompanyIds { get; set; } = new();

        /// <summary>
        /// The UTC timestamp at which the label type was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the label type was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }
    }
}
