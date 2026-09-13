namespace Boyles.PowerShell.Diagnostics
{
    /// <summary>
    /// A no-op <see cref="IHttpDiagnosticsSink"/>. <c>HttpClientBase</c> defaults to this
    /// implementation when no sink is supplied, so verbose diagnostics stay entirely
    /// opt-in and callers never need to null-check before recording.
    /// </summary>
    public sealed class NullHttpDiagnosticsSink : IHttpDiagnosticsSink
    {
        /// <summary>
        /// Shared singleton instance, since this implementation has no state.
        /// </summary>
        public static readonly NullHttpDiagnosticsSink Instance = new();

        /// <inheritdoc />
        public Task RecordAsync(HttpCallRecord record)
        {
            return Task.CompletedTask;
        }
    }
}
