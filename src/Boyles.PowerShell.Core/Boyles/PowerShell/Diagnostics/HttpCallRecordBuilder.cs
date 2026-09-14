using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.Diagnostics
{
    public sealed class HttpCallRecordBuilder
    {
        /// <summary>
        /// Header names whose values are replaced with a redacted placeholder. Comparison
        /// is case-insensitive. Extend this set if a platform introduces another secret header.
        /// </summary>
        public static readonly HashSet<string> RedactedHeaderNames = new(StringComparer.OrdinalIgnoreCase)
        {
            "Authorization",
            "X-Api-Key",
            "Api-Key",
            "Ocp-Apim-Subscription-Key",
            "X-Auth-Token",
        };

        /// <summary>
        /// Placeholder text substituted for redacted header values.
        /// </summary>
        private const string RedactedPlaceholder = "***redacted***";

        /// <summary>
        /// Builds a record for a completed attempt (success or a non-exception failure status).
        /// </summary>
        /// <param name="correlationId">Identifier shared across all attempts of this logical call.</param>
        /// <param name="attemptNumber">1-based attempt number.</param>
        /// <param name="sourceMethod">Name of the calling client method, for grouping in the UI.</param>
        /// <param name="startedAtUtc">When the request was sent.</param>
        /// <param name="requestMethod">The HTTP method used.</param>
        /// <param name="requestUri">The full request URI.</param>
        /// <param name="requestHeaders">Raw request headers, before redaction.</param>
        /// <param name="requestBody">Raw request body, if any.</param>
        /// <param name="responseStatusCode">The response status code.</param>
        /// <param name="responseReasonPhrase">The response reason phrase.</param>
        /// <param name="responseHeaders">Raw response headers, before redaction.</param>
        /// <param name="responseBody">Raw response body, if any.</param>
        /// <param name="isRetry">Whether this attempt is a retry of a previous one.</param>
        /// <param name="retryReason">Human-readable reason for the retry, if applicable.</param>
        /// <returns>A fully populated, redacted <see cref="HttpCallRecord"/>.</returns>
        public HttpCallRecord BuildForResponse(Guid correlationId, int attemptNumber, string sourceMethod, DateTimeOffset startedAtUtc, string requestMethod, string requestUri, IEnumerable<KeyValuePair<string, IEnumerable<string>>> requestHeaders, string? requestBody, int responseStatusCode, string? responseReasonPhrase, IEnumerable<KeyValuePair<string, IEnumerable<string>>> responseHeaders, string? responseBody, bool isRetry, string? retryReason)
        {
            var completedAtUtc = DateTimeOffset.UtcNow;

            return new HttpCallRecord
            {
                CallId = Guid.NewGuid(),
                CorrelationId = correlationId,
                AttemptNumber = attemptNumber,
                SourceMethod = sourceMethod,
                StartedAtUtc = startedAtUtc,
                CompletedAtUtc = completedAtUtc,
                DurationMs = (completedAtUtc - startedAtUtc).TotalMilliseconds,
                HttpMethod = requestMethod,
                RequestUri = requestUri,
                RequestHeaders = Redact(requestHeaders),
                RequestBody = PrettyPrintIfJson(requestBody),
                ResponseStatusCode = responseStatusCode,
                ResponseReasonPhrase = responseReasonPhrase,
                ResponseHeaders = Redact(responseHeaders),
                ResponseBody = PrettyPrintIfJson(responseBody),
                IsRetry = isRetry,
                RetryReason = retryReason,
                ExceptionMessage = null,
                Succeeded = responseStatusCode is >= 200 and < 300,
            };
        }

        /// <summary>
        /// Builds a record for an attempt that failed before a response was received,
        /// e.g. a timeout or a network-level exception.
        /// </summary>
        /// <param name="correlationId">Identifier shared across all attempts of this logical call.</param>
        /// <param name="attemptNumber">1-based attempt number.</param>
        /// <param name="sourceMethod">Name of the calling client method, for grouping in the UI.</param>
        /// <param name="startedAtUtc">When the request was sent.</param>
        /// <param name="requestMethod">The HTTP method used.</param>
        /// <param name="requestUri">The full request URI.</param>
        /// <param name="requestHeaders">Raw request headers, before redaction.</param>
        /// <param name="requestBody">Raw request body, if any.</param>
        /// <param name="exception">The exception that terminated the attempt.</param>
        /// <param name="isRetry">Whether this attempt is a retry of a previous one.</param>
        /// <returns>A fully populated, redacted <see cref="HttpCallRecord"/>.</returns>
        public HttpCallRecord BuildForException(Guid correlationId, int attemptNumber, string sourceMethod, DateTimeOffset startedAtUtc, string requestMethod, string requestUri, IEnumerable<KeyValuePair<string, IEnumerable<string>>> requestHeaders, string? requestBody, Exception exception, bool isRetry)
        {
            var completedAtUtc = DateTimeOffset.UtcNow;

            return new HttpCallRecord
            {
                CallId = Guid.NewGuid(),
                CorrelationId = correlationId,
                AttemptNumber = attemptNumber,
                SourceMethod = sourceMethod,
                StartedAtUtc = startedAtUtc,
                CompletedAtUtc = completedAtUtc,
                DurationMs = (completedAtUtc - startedAtUtc).TotalMilliseconds,
                HttpMethod = requestMethod,
                RequestUri = requestUri,
                RequestHeaders = Redact(requestHeaders),
                RequestBody = PrettyPrintIfJson(requestBody),
                ResponseStatusCode = null,
                ResponseReasonPhrase = null,
                ResponseHeaders = null,
                ResponseBody = null,
                IsRetry = isRetry,
                RetryReason = null,
                ExceptionMessage = exception.Message,
                Succeeded = false,
            };
        }

        /// <summary>
        /// Copies a header collection into a plain dictionary, replacing sensitive values
        /// with a redacted placeholder and flattening multi-value headers with a comma.
        /// </summary>
        /// <param name="headers">The raw header collection.</param>
        /// <returns>A redacted, read-only dictionary suitable for display.</returns>
        private static IReadOnlyDictionary<string, string> Redact(IEnumerable<KeyValuePair<string, IEnumerable<string>>> headers)
        {
            var result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

            foreach (var header in headers)
            {
                result[header.Key] = RedactedHeaderNames.Contains(header.Key)
                    ? RedactedPlaceholder
                    : string.Join(", ", header.Value);
            }

            return result;
        }

        /// <summary>
        /// Pretty-prints a body string as indented JSON if it parses as JSON; otherwise
        /// returns it unchanged. Keeps the diagnostics view readable for JSON APIs while
        /// still showing raw text for anything else.
        /// </summary>
        /// <param name="body">The raw body content, or null.</param>
        /// <returns>The pretty-printed body, the original body, or null.</returns>
        private static string? PrettyPrintIfJson(string? body)
        {
            if (string.IsNullOrWhiteSpace(body))
            {
                return body;
            }

            try
            {
                var token = JToken.Parse(body!);
                return token.ToString(Formatting.Indented);
            }
            catch (JsonException)
            {
                return body;
            }
        }
    }

}
