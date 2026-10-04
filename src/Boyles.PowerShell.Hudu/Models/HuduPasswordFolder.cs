using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A folder used to organize passwords within Hudu, scoped to a single company
    /// and optionally restricted to specific groups.
    /// </summary>
    public sealed class HuduPasswordFolder
    {
        /// <summary>
        /// The unique identifier of the password folder.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The identifier of the company that owns the folder.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// The display name of the folder.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The slug segment used in the folder's URL.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }

        /// <summary>
        /// The description of the folder.
        /// </summary>
        [JsonProperty("description")]
        public string? Description { get; set; }

        /// <summary>
        /// The security mode of the folder, for example <c>specific</c> when access is limited
        /// to the groups in <see cref="AllowedGroups"/>.
        /// </summary>
        [JsonProperty("security")]
        public string? Security { get; set; }

        /// <summary>
        /// The identifiers of the groups permitted to access the folder.
        /// </summary>
        [JsonProperty("allowed_groups")]
        public List<int>? AllowedGroups { get; set; }

        /// <summary>
        /// The UTC timestamp at which the folder was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the folder was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }
    }
}
