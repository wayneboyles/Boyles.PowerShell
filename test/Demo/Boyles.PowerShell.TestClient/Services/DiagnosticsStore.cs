using Boyles.PowerShell.Diagnostics;

namespace Boyles.PowerShell.TestClient.Services
{
    /// <summary>
    /// In-memory <see cref="IHttpDiagnosticsSink"/> that every <c>HttpClientBase</c>-derived
    /// client built by this app is wired to. Keeps a bounded, newest-first log of every HTTP
    /// attempt (including retries and 401 re-auth cycles) for the Diagnostics panel to render.
    /// </summary>
    public sealed class DiagnosticsStore : IHttpDiagnosticsSink
    {
        private const int MaxRecords = 200;

        private readonly object _gate = new();
        private readonly List<HttpCallRecord> _records = new();

        /// <summary>
        /// Raised after a new record is stored or the log is cleared, so subscribing
        /// components can re-render.
        /// </summary>
        public event Action? Changed;

        /// <summary>
        /// A snapshot of the current log, newest attempt first.
        /// </summary>
        public IReadOnlyList<HttpCallRecord> Records
        {
            get
            {
                lock (_gate)
                {
                    return _records.ToList();
                }
            }
        }

        public Task RecordAsync(HttpCallRecord record)
        {
            lock (_gate)
            {
                _records.Insert(0, record);
                if (_records.Count > MaxRecords)
                {
                    _records.RemoveAt(_records.Count - 1);
                }
            }

            Changed?.Invoke();
            return Task.CompletedTask;
        }

        public void Clear()
        {
            lock (_gate)
            {
                _records.Clear();
            }

            Changed?.Invoke();
        }
    }
}
