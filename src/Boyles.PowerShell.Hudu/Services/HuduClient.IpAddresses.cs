using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services;

/// <summary>
/// Partial class containing Hudu IpAddress-related API operations.
/// </summary>
public partial class HuduClient
{
    public HuduIpAddress GetIpAddress(int id) => Sync(GetIpAddressAsync(id));

    public async Task<HuduIpAddress> GetIpAddressAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/ip_addresses/{1}", ApiRoot, id);
        return await GetAsync<HuduIpAddress>(path, itemsProperty: "ip_addresses", ct: cancellationToken);
    }

    public List<HuduIpAddress> GetIpAddresses(Dictionary<string, string>? query = null) => Sync(GetIpAddressesAsync(query));

    public async Task<List<HuduIpAddress>> GetIpAddressesAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/ip_addresses", ApiRoot);
        return await GetAllPagesAsync<HuduIpAddress>(path, query, itemsProperty: "ip_addresses", ct: cancellationToken);
    }

    public HuduIpAddress NewIpAddress(object body) => Sync(NewIpAddressAsync(body));
    
    public async Task<HuduIpAddress> NewIpAddressAsync(object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/ip_addresses", ApiRoot);

        var wrapper = new
        {
            IpAddress = body
        };

        return await PostAsync<HuduIpAddress>(path, wrapper, itemsProperty: "IpAddress", ct: cancellationToken);
    }

    public HuduIpAddress UpdateIpAddress(int id, object body) => Sync(UpdateIpAddressAsync(id, body));

    public async Task<HuduIpAddress> UpdateIpAddressAsync(int id, object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/ip_addresses/{1}", ApiRoot, id);
        
        var wrapper = new
        {
            IpAddress = body
        };
        
        return await PutAsync<HuduIpAddress>(path, wrapper, itemsProperty: "IpAddress", ct: cancellationToken);
    }

    public void DeleteIpAddress(int id) => Sync(DeleteIpAddressAsync(id));

    public async Task DeleteIpAddressAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/ip_addresses/{1}", ApiRoot, id);
        _ = await DeleteAsync<HuduIpAddress>(path, itemsProperty: "IpAddress", ct: cancellationToken);
    }
}
