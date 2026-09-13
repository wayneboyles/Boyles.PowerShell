using System.Net;

namespace Boyles.PowerShell.Exceptions
{
    public sealed class ApiException : Exception
    {
        public HttpStatusCode StatusCode { get; }

        public string ResponseBody { get; }

        public ApiException(HttpStatusCode status, string body, string message) : base(message)
        {
            StatusCode = status;
            ResponseBody = body;
        }
    }
}
