using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A procedure in Hudu: a checklist of tasks that is either a reusable template or a run
    /// being worked through for a company or asset.
    /// </summary>
    public sealed class HuduProcedure
    {
        /// <summary>
        /// The unique identifier of the procedure.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The slug segment used in the procedure's URL.
        /// </summary>
        [JsonProperty("slug")]
        public string? Slug { get; set; }

        /// <summary>
        /// The display name of the procedure.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The description of the procedure.
        /// </summary>
        [JsonProperty("description")]
        public string? Description { get; set; }

        /// <summary>
        /// The total number of tasks in the procedure.
        /// </summary>
        [JsonProperty("total")]
        public int? Total { get; set; }

        /// <summary>
        /// The number of tasks in the procedure that have been completed.
        /// </summary>
        [JsonProperty("completed")]
        public int? Completed { get; set; }

        /// <summary>
        /// The relative URL of the procedure within the Hudu web interface.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }

        /// <summary>
        /// The type of Hudu object the procedure represents, for example <c>Process</c>.
        /// </summary>
        [JsonProperty("object_type")]
        public string? ObjectType { get; set; }

        /// <summary>
        /// The identifier of the company the procedure belongs to, or <see langword="null"/> for a global procedure.
        /// </summary>
        [JsonProperty("company_id")]
        public int? CompanyId { get; set; }

        /// <summary>
        /// The name of the company the procedure belongs to.
        /// </summary>
        [JsonProperty("company_name")]
        public string? CompanyName { get; set; }

        /// <summary>
        /// The share of tasks completed, formatted as a percentage string such as <c>0%</c>.
        /// </summary>
        [JsonProperty("completion_percentage")]
        public string? CompletionPercentage { get; set; }

        /// <summary>
        /// The UTC timestamp at which the procedure was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the procedure was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }

        /// <summary>
        /// The parent procedure that this procedure was started from, as reported by the Hudu API.
        /// </summary>
        [JsonProperty("parent_procedure")]
        public string? ParentProcedure { get; set; }

        /// <summary>
        /// Indicates whether the procedure is a run (an executing instance) rather than a template.
        /// </summary>
        [JsonProperty("run")]
        public bool? Run { get; set; }

        /// <summary>
        /// The identifier of the parent procedure this run was started from, or <see langword="null"/>
        /// if the procedure is not a run.
        /// </summary>
        [JsonProperty("parent_process_id")]
        public int? ParentProcessId { get; set; }

        /// <summary>
        /// The scope of the procedure, for example <c>company</c> or <c>global</c>.
        /// </summary>
        [JsonProperty("process_type")]
        public string? ProcessType { get; set; }

        /// <summary>
        /// The current status of the procedure, for example <c>Not Started</c>.
        /// </summary>
        [JsonProperty("status")]
        public string? Status { get; set; }

        /// <summary>
        /// The asset the procedure is associated with, as reported by the Hudu API.
        /// </summary>
        [JsonProperty("asset")]
        public string? Asset { get; set; }

        /// <summary>
        /// The public URL at which the procedure can be shared without signing in to Hudu.
        /// </summary>
        [JsonProperty("share_url")]
        public string? ShareUrl { get; set; }

        /// <summary>
        /// The tasks that make up the procedure, as raw JSON objects.
        /// </summary>
        [JsonProperty("procedure_tasks_attributes")]
        public List<JObject>? ProcedureTasksAttributes { get; set; }
    }
}
