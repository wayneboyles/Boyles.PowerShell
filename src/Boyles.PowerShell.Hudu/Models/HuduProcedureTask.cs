using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A single task within a <see cref="HuduProcedure"/>, optionally assigned to users and nested under a parent task.
    /// </summary>
    public sealed class HuduProcedureTask
    {
        /// <summary>
        /// The unique identifier of the task.
        /// </summary>
        [JsonProperty("id")]
        public int? Id { get; set; }

        /// <summary>
        /// The display name of the task.
        /// </summary>
        [JsonProperty("name")]
        public string? Name { get; set; }

        /// <summary>
        /// The description of the task.
        /// </summary>
        [JsonProperty("description")]
        public string? Description { get; set; }

        /// <summary>
        /// The position of the task within its procedure, used for ordering.
        /// </summary>
        [JsonProperty("position")]
        public int? Position { get; set; }

        /// <summary>
        /// The priority of the task, for example <c>unsure</c>.
        /// </summary>
        [JsonProperty("priority")]
        public string? Priority { get; set; }

        /// <summary>
        /// Indicates whether the task has been completed.
        /// </summary>
        [JsonProperty("completed")]
        public bool? Completed { get; set; }

        /// <summary>
        /// The date on which the task was completed, as reported by the Hudu API.
        /// </summary>
        [JsonProperty("completed_date")]
        public string? CompletedDate { get; set; }

        /// <summary>
        /// Notes recorded when the task was completed.
        /// </summary>
        [JsonProperty("completion_notes")]
        public string? CompletionNotes { get; set; }

        /// <summary>
        /// The date on which the task is due.
        /// </summary>
        [JsonProperty("due_date")]
        public DateTime? DueDate { get; set; }

        /// <summary>
        /// The due date formatted for display by the Hudu API.
        /// </summary>
        [JsonProperty("formatted_due_date")]
        public string? FormattedDueDate { get; set; }

        /// <summary>
        /// The identifier of the user associated with the task.
        /// </summary>
        [JsonProperty("user_id")]
        public int? UserId { get; set; }

        /// <summary>
        /// The name of the user associated with the task.
        /// </summary>
        [JsonProperty("user_name")]
        public string? UserName { get; set; }

        /// <summary>
        /// The identifiers of the users the task is assigned to.
        /// </summary>
        [JsonProperty("assigned_users")]
        public List<int>? AssignedUsers { get; set; }

        /// <summary>
        /// The identifier of the first user the task is assigned to.
        /// </summary>
        [JsonProperty("first_assigned_user_id")]
        public int? FirstAssignedUserId { get; set; }

        /// <summary>
        /// The name of the first user the task is assigned to.
        /// </summary>
        [JsonProperty("first_assigned_user_name")]
        public string? FirstAssignedUserName { get; set; }

        /// <summary>
        /// The initials of the first user the task is assigned to.
        /// </summary>
        [JsonProperty("first_assigned_user_initials")]
        public string? FirstAssignedUserInitials { get; set; }

        /// <summary>
        /// The identifier of the procedure the task belongs to.
        /// </summary>
        [JsonProperty("procedure_id")]
        public int? ProcedureId { get; set; }

        /// <summary>
        /// Indicates whether the task is optional.
        /// </summary>
        [JsonProperty("optional")]
        public bool? Optional { get; set; }

        /// <summary>
        /// The identifier of the parent task, or <see langword="null"/> for a top level task.
        /// </summary>
        [JsonProperty("parent_task_id")]
        public int? ParentTaskId { get; set; }

        /// <summary>
        /// The identifiers of the tasks nested under this task.
        /// </summary>
        [JsonProperty("subtask_ids")]
        public List<int>? SubtaskIds { get; set; }

        /// <summary>
        /// The number of tasks nested under this task.
        /// </summary>
        [JsonProperty("subtask_count")]
        public int? SubtaskCount { get; set; }

        /// <summary>
        /// Indicates whether the task has any nested tasks.
        /// </summary>
        [JsonProperty("has_subtasks")]
        public bool? HasSubtasks { get; set; }

        /// <summary>
        /// The URL of the task within the Hudu web interface.
        /// </summary>
        [JsonProperty("url")]
        public string? Url { get; set; }

        /// <summary>
        /// The UTC timestamp at which the task was created.
        /// </summary>
        [JsonProperty("created_at")]
        public DateTimeOffset? CreatedAt { get; set; }

        /// <summary>
        /// The UTC timestamp at which the task was last modified.
        /// </summary>
        [JsonProperty("updated_at")]
        public DateTimeOffset? UpdatedAt { get; set; }
    }
}
