using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services;

/// <summary>
/// Partial class containing Hudu Group-related API operations. Groups are read-only via the API.
/// </summary>
public partial class HuduClient
{
    /// <summary>
    /// Retrieves a single Group by its ID synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Group ID.</param>
    /// <returns>The matching <see cref="HuduGroup"/>.</returns>
    public HuduGroup GetGroup(int id) => Sync(GetGroupAsync(id));

    /// <summary>
    /// Retrieves a single Group by its ID asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Group ID.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the matching <see cref="HuduGroup"/>.</returns>
    public async Task<HuduGroup> GetGroupAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/groups/{1}", ApiRoot, id);
        return await GetAsync<HuduGroup>(path, itemsProperty: "group", ct: cancellationToken);
    }

    /// <summary>
    /// Retrieves all Groups from the Hudu API synchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <returns>A list of all matching <see cref="HuduGroup"/> records.</returns>
    public List<HuduGroup> GetGroups(Dictionary<string, string>? query = null) => Sync(GetGroupsAsync(query));

    /// <summary>
    /// Retrieves all Groups from the Hudu API asynchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to a list of all matching <see cref="HuduGroup"/> records.</returns>
    public async Task<List<HuduGroup>> GetGroupsAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/groups", ApiRoot);
        return await GetAllHuduPagesAsync<HuduGroup>(path, query, "groups", cancellationToken);
    }
}
