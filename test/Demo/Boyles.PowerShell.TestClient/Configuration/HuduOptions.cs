namespace Boyles.PowerShell.TestClient.Configuration
{
    /// <summary>
    /// Bound from the "Hudu" configuration section. In development this is expected to come from
    /// User Secrets (<c>dotnet user-secrets set "Hudu:BaseUrl" ...</c>) rather than appsettings*.json,
    /// so a real API key never lands in source control. Add a sibling *Options class + config
    /// section the same way for each future service module's credentials.
    /// </summary>
    public sealed class HuduOptions
    {
        public string? BaseUrl { get; set; }

        public string? ApiKey { get; set; }
    }
}
