using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services;

/// <summary>
/// Partial class containing Hudu flag-related API operations.
/// </summary>
public partial class HuduClient
{
    /// <summary>
    /// Retrieves a single flag by its ID synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu flag ID.</param>
    /// <returns>The matching <see cref="HuduFlag"/>.</returns>
    public HuduFlag GetFlag(int id) => Sync(GetFlagAsync(id));

    /// <summary>
    /// Retrieves a single flag by its ID asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu flag ID.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the matching <see cref="HuduFlag"/>.</returns>
    public async Task<HuduFlag> GetFlagAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/flags/{1}", ApiRoot, id);
        return await GetAsync<HuduFlag>(path, itemsProperty: "flag", ct: cancellationToken);
    }

    /// <summary>
    /// Retrieves all flags from the Hudu API synchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <returns>A list of all matching <see cref="HuduFlag"/> records.</returns>
    public List<HuduFlag> GetFlags(Dictionary<string, string>? query = null) => Sync(GetFlagsAsync(query));

    /// <summary>
    /// Retrieves all flags from the Hudu API asynchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to a list of all matching <see cref="HuduFlag"/> records.</returns>
    public async Task<List<HuduFlag>> GetFlagsAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/flags", ApiRoot);
        return await GetAllPagesAsync<HuduFlag>(path, query, itemsProperty: "flags", ct: cancellationToken);
    }

    /// <summary>
    /// Creates a new flag in Hudu asynchronously.
    /// </summary>
    /// <param name="body">
    /// The request body representing the flag to create. Wrapped in a <c>flag</c> envelope before sending.
    /// </param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the newly created <see cref="HuduFlag"/>.</returns>
    public async Task<HuduFlag> NewFlagAsync(object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/flags", ApiRoot);

        var wrapper = new
        {
            flag = body
        };

        return await PostAsync<HuduFlag>(path, wrapper, itemsProperty: "flag", ct: cancellationToken);
    }

    /// <summary>
    /// Updates an existing flag in Hudu synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu flag ID.</param>
    /// <param name="body">The request body containing the fields to update.</param>
    /// <returns>The updated <see cref="HuduFlag"/>.</returns>
    public HuduFlag UpdateFlag(int id, object body) => Sync(UpdateFlagAsync(id, body));

    /// <summary>
    /// Updates an existing flag in Hudu asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu flag ID.</param>
    /// <param name="body">The request body containing the fields to update.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the updated <see cref="HuduFlag"/>.</returns>
    public async Task<HuduFlag> UpdateFlagAsync(int id, object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/flags/{1}", ApiRoot, id);
        return await PutAsync<HuduFlag>(path, body, itemsProperty: "flag", ct: cancellationToken);
    }

    /// <summary>
    /// Deletes a flag from Hudu synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu flag ID.</param>
    public void DeleteFlag(int id) => Sync(DeleteFlagAsync(id));

    /// <summary>
    /// Deletes a flag from Hudu asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu flag ID.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task that completes when the flag has been deleted.</returns>
    public async Task DeleteFlagAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/flags/{1}", ApiRoot, id);
        _ = await DeleteAsync<HuduFlag>(path, itemsProperty: "flag", ct: cancellationToken);
    }
}
