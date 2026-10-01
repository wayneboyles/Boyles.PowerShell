using System.Net;

namespace Boyles.PowerShell.Exceptions
{
    /// <summary>
    /// Thrown by <c>HttpClientBase</c> when an API returns a non-success status code that is not
    /// (or is no longer) retryable. Carries the status code and raw response body so callers can
    /// inspect the API's own error payload.
    /// </summary>
    public sealed class ApiException : Exception
    {
        /// <summary>
        /// The HTTP status code the API returned.
        /// </summary>
        public HttpStatusCode StatusCode { get; }

        /// <summary>
        /// The raw response body, typically the API's JSON error payload. May be empty.
        /// </summary>
        public string ResponseBody { get; }

        /// <summary>
        /// Initializes a new instance of the ApiException class.
        /// </summary>
        /// <param name="status">The HTTP status code the API returned.</param>
        /// <param name="body">The raw response body.</param>
        /// <param name="message">The exception message.</param>
        public ApiException(HttpStatusCode status, string body, string message) : base(message)
        {
            StatusCode = status;
            ResponseBody = body;
        }
    }
}
