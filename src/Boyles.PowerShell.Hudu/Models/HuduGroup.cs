using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A group of Hudu users used to grant shared access to companies and resources.
    /// </summary>
    public sealed class HuduGroup
    {
        /// <summary>
        /// The unique identifier of the group.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The display name of the group.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The slug segment used in the group's URL.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }

        /// <summary>
        /// The relative URL of the group within the Hudu web interface.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }

        /// <summary>
        /// Indicates whether this is the default group that new users are added to.
        /// </summary>
        [JsonProperty("default")]
        public bool? Default { get; set; }

        /// <summary>
        /// The UTC timestamp at which the group was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the group was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }

        /// <summary>
        /// The number of users that belong to the group.
        /// </summary>
        [JsonProperty("member_count")]
        public int? MemberCount { get; set; }

        /// <summary>
        /// The users that belong to the group. Admins and super admins are excluded by the Hudu API.
        /// </summary>
        [JsonProperty("members")]
        public List<HuduGroupMember> Members { get; set; } = new();
    }
}
