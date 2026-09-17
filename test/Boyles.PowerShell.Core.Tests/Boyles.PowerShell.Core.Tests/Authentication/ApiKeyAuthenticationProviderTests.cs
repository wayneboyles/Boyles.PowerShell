namespace Boyles.PowerShell.Authentication
{
    public class ApiKeyAuthenticationProviderTests
    {
        [Fact]
        public async Task Bearer_ApplyAsync_SetsAuthorizationHeaderWithBearerPrefix()
        {
            var provider = ApiKeyAuthenticationProvider.Bearer("token123");
            using var request = new HttpRequestMessage(HttpMethod.Get, "https://example.test/");

            await provider.ApplyAsync(request, forceRefresh: false, CancellationToken.None);

            Assert.Equal("Bearer token123", request.Headers.GetValues("Authorization").Single());
        }

        [Fact]
        public async Task Header_ApplyAsync_SetsCustomHeaderNameAndValue()
        {
            var provider = ApiKeyAuthenticationProvider.Header("x-api-key", "secret-value");
            using var request = new HttpRequestMessage(HttpMethod.Get, "https://example.test/");

            await provider.ApplyAsync(request, forceRefresh: false, CancellationToken.None);

            Assert.Equal("secret-value", request.Headers.GetValues("x-api-key").Single());
        }

        [Fact]
        public async Task ApplyAsync_ForceRefreshTrue_StillAppliesHeader()
        {
            // Stateless provider: forceRefresh (used by HttpClientBase after a 401) has nothing
            // to invalidate, so it should behave identically to a normal apply.
            var provider = ApiKeyAuthenticationProvider.Header("x-api-key", "secret-value");
            using var request = new HttpRequestMessage(HttpMethod.Get, "https://example.test/");

            await provider.ApplyAsync(request, forceRefresh: true, CancellationToken.None);

            Assert.Equal("secret-value", request.Headers.GetValues("x-api-key").Single());
        }

        [Fact]
        public async Task InvalidateAsync_CompletesSuccessfullyAndIsANoOp()
        {
            var provider = ApiKeyAuthenticationProvider.Header("x-api-key", "secret-value");

            await provider.InvalidateAsync(CancellationToken.None);

            using var request = new HttpRequestMessage(HttpMethod.Get, "https://example.test/");
            await provider.ApplyAsync(request, forceRefresh: false, CancellationToken.None);

            Assert.Equal("secret-value", request.Headers.GetValues("x-api-key").Single());
        }
    }
}
