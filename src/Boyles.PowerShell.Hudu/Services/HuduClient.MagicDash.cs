using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services;

/// <summary>
/// Partial class containing Hudu MagicDash-related API operations.
/// </summary>
public partial class HuduClient
{
    /// <summary>
    /// Retrieves all MagicDash from the Hudu API synchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <returns>A list of all matching <see cref="HuduMagicDash"/> records.</returns>
    public List<HuduMagicDash> GetMagicDashes(Dictionary<string, string>? query = null) => Sync(GetMagicDashesAsync(query));

    /// <summary>
    /// Retrieves all MagicDash from the Hudu API asynchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to a list of all matching <see cref="HuduMagicDash"/> records.</returns>
    public async Task<List<HuduMagicDash>> GetMagicDashesAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/magic_dash", ApiRoot);
        return await GetAllHuduPagesAsync<HuduMagicDash>(path, query, "", cancellationToken);
    }

    /// <summary>
    /// Creates a new MagicDash in Hudu synchronously.
    /// </summary>
    /// <param name="body">
    /// The request body representing the MagicDash to create. Wrapped in a <c>magic_dash</c> envelope before sending.
    /// </param>
    /// <returns>The newly created <see cref="HuduMagicDash"/>.</returns>
    public HuduMagicDash NewMagicDash(object body) => Sync(NewMagicDashAsync(body));

    /// <summary>
    /// Creates a new MagicDash in Hudu asynchronously.
    /// </summary>
    /// <param name="body">
    /// The request body representing the MagicDash to create. Wrapped in a <c>magic_dash</c> envelope before sending.
    /// </param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the newly created <see cref="HuduMagicDash"/>.</returns>
    public async Task<HuduMagicDash> NewMagicDashAsync(object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/magic_dash", ApiRoot);

        return await PostAsync<HuduMagicDash>(path, body, ct: cancellationToken);
    }

    /// <summary>
    /// Deletes a MagicDash from Hudu synchronously.
    /// </summary>
    /// <param name="id">The unique identifier of the MagicDash to delete.</param>
    public void DeleteMagicDash(int id, object? body = null) => Sync(DeleteMagicDashAsync(id, body));

    /// <summary>
    /// Deletes a MagicDash from Hudu asynchronously.
    /// </summary>
    /// <param name="id">The unique identifier of the MagicDash to delete.</param>
    /// <param name="body">The request body when deleting by Title and Company Name.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task that completes when the MagicDash has been deleted.</returns>
    public async Task DeleteMagicDashAsync(int id, object? body = null, CancellationToken cancellationToken = default)
    {
        string path;

        if (id > 0)
        {
            path = string.Format(CultureInfo.InvariantCulture, "{0}/magic_dash/{1}", ApiRoot, id);
            _ = await DeleteAsync<HuduMagicDash>(path, ct: cancellationToken);
        }
        else
        {
            path = string.Format(CultureInfo.InvariantCulture, "{0}/magic_dash", ApiRoot);
            _ = await InvokeAsync(path, "DELETE", null, body, cancellationToken: cancellationToken);
        }
    }
}
