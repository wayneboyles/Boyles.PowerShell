using System;
using System.Net;
using System.Net.Http;

namespace Boyles.PowerShell.Http
{
    /// <summary>
    /// Owns the single <see cref="HttpMessageHandler"/> shared by every <c>HttpClientBase</c>
    /// instance, so all clients pool sockets instead of each opening (and leaking) their own.
    /// </summary>
    internal static class HttpTransport
    {
        /// <summary>
        /// The process-wide handler. Clients must wrap it with <c>disposeHandler: false</c>.
        /// </summary>
        public static readonly HttpMessageHandler Shared = Create();

        /// <summary>
        /// Builds the platform-appropriate handler: a <c>SocketsHttpHandler</c> with a bounded
        /// connection lifetime (so DNS changes are picked up) on .NET 8+, otherwise an
        /// <see cref="HttpClientHandler"/> with TLS 1.2 forced on for Windows PowerShell 5.1.
        /// </summary>
        /// <returns>The handler to share.</returns>
        private static HttpMessageHandler Create()
        {
#if NET8_0_OR_GREATER
            return new SocketsHttpHandler
            {
                PooledConnectionLifetime = TimeSpan.FromMinutes(5),
                AutomaticDecompression = System.Net.DecompressionMethods.All
            };
#else
            try { 
                ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12; 
            } catch { }
        
            return new HttpClientHandler
            {
                AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate
            };
#endif
        }

    }
}