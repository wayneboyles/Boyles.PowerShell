using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services;

/// <summary>
/// Partial class containing Hudu IpAddress-related API operations.
/// </summary>
public partial class HuduClient
{
    /// <summary>
    /// Retrieves a single IP Address by its ID synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu IP Address ID.</param>
    /// <returns>The matching <see cref="HuduIpAddress"/>.</returns>
    public HuduIpAddress GetIpAddress(int id) => Sync(GetIpAddressAsync(id));

    /// <summary>
    /// Retrieves a single IP Address by its ID asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu IP Address ID.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the matching <see cref="HuduIpAddress"/>.</returns>
    public async Task<HuduIpAddress> GetIpAddressAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/ip_addresses/{1}", ApiRoot, id);
        return await GetAsync<HuduIpAddress>(path, itemsProperty: "ip_addresses", ct: cancellationToken);
    }

    /// <summary>
    /// Retrieves all IP Addresses from the Hudu API synchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <returns>A list of all matching <see cref="HuduIpAddress"/> records.</returns>
    public List<HuduIpAddress> GetIpAddresses(Dictionary<string, string>? query = null) => Sync(GetIpAddressesAsync(query));

    /// <summary>
    /// Retrieves all IP Addresses from the Hudu API asynchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to a list of all matching <see cref="HuduIpAddress"/> records.</returns>
    public async Task<List<HuduIpAddress>> GetIpAddressesAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/ip_addresses", ApiRoot);
        return await GetAllHuduPagesAsync<HuduIpAddress>(path, query, "ip_addresses", cancellationToken);
    }

    /// <summary>
    /// Creates a new IP Address in Hudu synchronously.
    /// </summary>
    /// <param name="body">
    /// The request body representing the IP Address to create. Wrapped in an <c>ip_address</c> envelope before sending.
    /// </param>
    /// <returns>The newly created <see cref="HuduIpAddress"/>.</returns>
    public HuduIpAddress NewIpAddress(object body) => Sync(NewIpAddressAsync(body));

    /// <summary>
    /// Creates a new IP Address in Hudu asynchronously.
    /// </summary>
    /// <param name="body">
    /// The request body representing the IP Address to create. Wrapped in an <c>ip_address</c> envelope before sending.
    /// </param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the newly created <see cref="HuduIpAddress"/>.</returns>
    public async Task<HuduIpAddress> NewIpAddressAsync(object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/ip_addresses", ApiRoot);

        var wrapper = new
        {
            IpAddress = body
        };

        return await PostAsync<HuduIpAddress>(path, wrapper, itemsProperty: "ip_address", ct: cancellationToken);
    }

    /// <summary>
    /// Updates an existing IP Address in Hudu synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu IP Address ID.</param>
    /// <param name="body">The request body containing the fields to update.</param>
    /// <returns>The updated <see cref="HuduIpAddress"/>.</returns>
    public HuduIpAddress UpdateIpAddress(int id, object body) => Sync(UpdateIpAddressAsync(id, body));

    /// <summary>
    /// Updates an existing IP Address in Hudu asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu IP Address ID.</param>
    /// <param name="body">The request body containing the fields to update.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the updated <see cref="HuduIpAddress"/>.</returns>
    public async Task<HuduIpAddress> UpdateIpAddressAsync(int id, object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/ip_addresses/{1}", ApiRoot, id);

        var wrapper = new
        {
            IpAddress = body
        };

        return await PutAsync<HuduIpAddress>(path, wrapper, itemsProperty: "ip_address", ct: cancellationToken);
    }

    /// <summary>
    /// Deletes an IP Address from Hudu synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu IP Address ID.</param>
    public void DeleteIpAddress(int id) => Sync(DeleteIpAddressAsync(id));

    /// <summary>
    /// Deletes an IP Address from Hudu asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu IP Address ID.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task that completes when the IP Address has been deleted.</returns>
    public async Task DeleteIpAddressAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/ip_addresses/{1}", ApiRoot, id);
        _ = await DeleteAsync<HuduIpAddress>(path, itemsProperty: "ip_address", ct: cancellationToken);
    }
}
