namespace Boyles.PowerShell.Authentication
{
    public sealed class ApiKeyAuthenticationProvider : IAuthenticationProvider
    {
        private readonly string _name;
        private readonly string _value;

        private ApiKeyAuthenticationProvider(string name, string value)
        {
            _name = name; _value = value;
        }

        public static ApiKeyAuthenticationProvider Bearer(string token)
            => new("Authorization", "Bearer " + token);

        public static ApiKeyAuthenticationProvider Header(string name, string value)
            => new(name, value);

        public Task ApplyAsync(HttpRequestMessage request, bool forceRefresh, CancellationToken ct)
        {
            request.Headers.TryAddWithoutValidation(_name, _value);
            return Task.CompletedTask;
        }

        public Task InvalidateAsync(CancellationToken ct) => Task.CompletedTask; // nothing to renew
    }
}
