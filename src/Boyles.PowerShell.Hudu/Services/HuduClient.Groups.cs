using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services;

/// <summary>
/// Partial class containing Hudu Group-related API operations.
/// </summary>
public partial class HuduClient
{
    public HuduGroup GetGroup(int id) => Sync(GetGroupAsync(id));

    public async Task<HuduGroup> GetGroupAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/groups/{1}", ApiRoot, id);
        return await GetAsync<HuduGroup>(path, itemsProperty: "group", ct: cancellationToken);
    }

    public List<HuduGroup> GetGroups(Dictionary<string, string>? query = null) => Sync(GetGroupsAsync(query));

    public async Task<List<HuduGroup>> GetGroupsAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/groups", ApiRoot);
        return await GetAllPagesAsync<HuduGroup>(path, query, itemsProperty: "groups", ct: cancellationToken);
    }
}
