using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A folder used to organize knowledge base articles or photos within Hudu,
    /// either globally or scoped to a single company.
    /// </summary>
    public sealed class HuduFolder
    {
        /// <summary>
        /// The unique identifier of the folder.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The identifier of the owning company, or <see langword="null"/> for a global folder.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// The icon displayed alongside the folder in the Hudu web interface.
        /// </summary>
        [JsonProperty("icon")]
        public string? Icon { get; set; }

        /// <summary>
        /// The description of the folder.
        /// </summary>
        [JsonProperty("description")]
        public string? Description { get; set; }

        /// <summary>
        /// The display name of the folder.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The identifier of the parent folder, or <see langword="null"/> for a top level folder.
        /// </summary>
        [JsonProperty("parent_folder_id")]
        public int? ParentFolderId { get; set; }

        /// <summary>
        /// The type of content the folder holds, either <c>article</c> or <c>photo</c>.
        /// This value can only be set when the folder is created.
        /// </summary>
        [JsonProperty("folder_type")]
        public string? FolderType { get; set; }

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
