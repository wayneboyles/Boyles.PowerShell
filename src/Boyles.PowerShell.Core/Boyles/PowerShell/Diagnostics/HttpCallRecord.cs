using System;
using System.Collections.Generic;
using System.Text;

namespace Boyles.PowerShell.Diagnostics
{
    /// <summary>
    /// An immutable record of a single HTTP attempt made by an <c>HttpClientBase</c>-derived
    /// client. One logical API call may produce several of these - for example a 401 that
    /// triggers a token refresh and a retry will produce two records sharing the same
    /// <see cref="CorrelationId"/>. Consumers (such as the Blazor test client) use these
    /// to render a full request/response trail for debugging.
    /// </summary>
    public sealed class HttpCallRecord
    {
        /// <summary>
        /// Unique identifier for this specific attempt.
        /// </summary>
        public Guid? CallId { get; set; }

        /// <summary>
        /// Shared identifier across every attempt that belongs to the same logical call,
        /// including retries and the request that preceded a 401 token refresh.
        /// </summary>
        public Guid? CorrelationId { get; set; }

        /// <summary>
        /// 1-based attempt number within the retry pipeline for this logical call.
        /// </summary>
        public int? AttemptNumber { get; set; }

        /// <summary>
        /// Name of the client method that setiated the call, e.g. <c>HuduClient.GetCompanyAsync</c>.
        /// Populate this from the calling method so the log can be filtered/grouped by operation.
        /// </summary>
        public string? SourceMethod { get; set; }

        /// <summary>
        /// UTC timestamp when the request was sent.
        /// </summary>
        public DateTimeOffset? StartedAtUtc { get; set; }

        /// <summary>
        /// UTC timestamp when the response (or exception) was received.
        /// </summary>
        public DateTimeOffset? CompletedAtUtc { get; set; }

        /// <summary>
        /// Wall-clock duration of this attempt, in milliseconds.
        /// </summary>
        public double? DurationMs { get; set; }

        /// <summary>
        /// HTTP method of the request, e.g. GET, POST.
        /// </summary>
        public string? HttpMethod { get; set; }

        /// <summary>
        /// Full request URI, including query string.
        /// </summary>
        public string? RequestUri { get; set; }

        /// <summary>
        /// Request headers. Sensitive values (Authorization, API keys, etc.) are replaced
        /// with a redacted placeholder before this record is created.
        /// </summary>
        public IReadOnlyDictionary<string, string>? RequestHeaders { get; set; }

        /// <summary>
        /// Request body, pretty-printed if it was JSON. Null for methods with no body.
        /// </summary>
        public string? RequestBody { get; set; }

        /// <summary>
        /// HTTP status code of the response. Null if the call threw before a response was received.
        /// </summary>
        public int? ResponseStatusCode { get; set; }

        /// <summary>
        /// HTTP reason phrase of the response, e.g. "OK" or "Too Many Requests".
        /// </summary>
        public string? ResponseReasonPhrase { get; set; }

        /// <summary>
        /// Response headers, including trailing headers where available.
        /// </summary>
        public IReadOnlyDictionary<string, string>? ResponseHeaders { get; set; }

        /// <summary>
        /// Response body, pretty-printed if it was JSON.
        /// </summary>
        public string? ResponseBody { get; set; }

        /// <summary>
        /// True if this attempt is a retry of a previous attempt sharing the same <see cref="CorrelationId"/>.
        /// </summary>
        public bool? IsRetry { get; set; }

        /// <summary>
        /// Human-readable reason a retry occurred, e.g. "401 - token refreshed" or
        /// "503 - backoff 1284ms". Null on a first attempt.
        /// </summary>
        public string? RetryReason { get; set; }

        /// <summary>
        /// Exception message if the attempt failed before or during the HTTP call itself,
        /// as opposed to the API returning a non-success status code.
        /// </summary>
        public string? ExceptionMessage { get; set; }

        /// <summary>
        /// True if the attempt completed with a success status code and no exception.
        /// </summary>
        public bool? Succeeded { get; set; }
    }

}
