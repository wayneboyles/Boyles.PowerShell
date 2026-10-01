namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// Version information returned by Hudu's <c>/api_info</c> endpoint.
    /// </summary>
    public sealed class HuduApiInfo
    {
        /// <summary>
        /// The Hudu application version running on the instance, e.g. "2.37.1".
        /// </summary>
        public string? Version { get; set; }

        /// <summary>
        /// The release date of that version, as reported by Hudu.
        /// </summary>
        public string? Date { get; set; }
    }
}
