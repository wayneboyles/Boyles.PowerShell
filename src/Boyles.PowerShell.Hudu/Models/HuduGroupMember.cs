using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A Hudu user as listed within the membership of a <see cref="HuduGroup"/>.
    /// </summary>
    public sealed class HuduGroupMember
    {
        /// <summary>
        /// The unique identifier of the user.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The first name of the user.
        /// </summary>
        [JsonProperty("first_name")]
        public string? FirstName { get; set; }

        /// <summary>
        /// The last name of the user.
        /// </summary>
        [JsonProperty("last_name")]
        public string? LastName { get; set; }

        /// <summary>
        /// The email address of the user.
        /// </summary>
        [JsonProperty("email")]
        public string? Email { get; set; }

        /// <summary>
        /// The security level assigned to the user, which determines their permissions in Hudu.
        /// </summary>
        [JsonProperty("security_level")]
        public string? SecurityLevel { get; set; }

        /// <summary>
        /// The slug segment used in the user's URL.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }
    }
}
