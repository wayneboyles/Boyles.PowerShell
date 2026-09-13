using System;
using System.Net;
using System.Net.Http;

namespace Boyles.PowerShell.Http
{
    internal static class HttpTransport
    {
        public static readonly HttpMessageHandler Shared = Create();

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