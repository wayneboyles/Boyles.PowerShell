namespace Boyles.PowerShell.Diagnostics
{
    /// <summary>
    /// Receives an <see cref="HttpCallRecord"/> for every HTTP attempt made by an
    /// <c>HttpClientBase</c>-derived client. Implementations decide what to do with it -
    /// write to a log, push to a UI in real time, discard it entirely, etc.
    /// <c>HttpClientBase</c> depends only on this interface, so Core never takes a
    /// dependency on any particular consumer (Blazor, console, PowerShell host).
    /// </summary>
    public interface IHttpDiagnosticsSink
    {
        /// <summary>
        /// Called once per HTTP attempt, after the response has been received or the
        /// attempt has failed. Implementations should not throw; a diagnostics failure
        /// must never take down the underlying API call.
        /// </summary>
        /// <param name="record">
        /// The full detail of the attempt that just completed.
        /// </param>
        /// <returns>
        /// A task that completes when the record has been handed off.
        /// </returns>
        Task RecordAsync(HttpCallRecord record);
    }
}
