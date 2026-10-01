using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services;

/// <summary>
/// Partial class containing Hudu Folder-related API operations.
/// </summary>
public partial class HuduClient
{
    /// <summary>
    /// Retrieves a single Folder by its ID synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Folder ID.</param>
    /// <returns>The matching <see cref="HuduFolder"/>.</returns>
    public HuduFolder GetFolder(int id) => Sync(GetFolderAsync(id));

    /// <summary>
    /// Retrieves a single Folder by its ID asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Folder ID.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the matching <see cref="HuduFolder"/>.</returns>
    public async Task<HuduFolder> GetFolderAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/folders/{1}", ApiRoot, id);
        return await GetAsync<HuduFolder>(path, itemsProperty: "folders", ct: cancellationToken);
    }

    /// <summary>
    /// Retrieves all Folders from the Hudu API synchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <returns>A list of all matching <see cref="HuduFolder"/> records.</returns>
    public List<HuduFolder> GetFolders(Dictionary<string, string>? query = null) => Sync(GetFoldersAsync(query));

    /// <summary>
    /// Retrieves all Folders from the Hudu API asynchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to a list of all matching <see cref="HuduFolder"/> records.</returns>
    public async Task<List<HuduFolder>> GetFoldersAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/folders", ApiRoot);
        return await GetAllHuduPagesAsync<HuduFolder>(path, query, "folders", cancellationToken);
    }

    /// <summary>
    /// Creates a new Folder in Hudu synchronously.
    /// </summary>
    /// <param name="body">
    /// The request body representing the Folder to create. Wrapped in a <c>folder</c> envelope before sending.
    /// </param>
    /// <returns>The newly created <see cref="HuduFolder"/>.</returns>
    public HuduFolder NewFolder(object body) => Sync(NewFolderAsync(body));

    /// <summary>
    /// Creates a new Folder in Hudu asynchronously.
    /// </summary>
    /// <param name="body">
    /// The request body representing the Folder to create. Wrapped in a <c>folder</c> envelope before sending.
    /// </param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the newly created <see cref="HuduFolder"/>.</returns>
    public async Task<HuduFolder> NewFolderAsync(object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/folders", ApiRoot);

        var wrapper = new
        {
            folder = body
        };

        return await PostAsync<HuduFolder>(path, wrapper, itemsProperty: "folder", ct: cancellationToken);
    }

    /// <summary>
    /// Updates an existing Folder in Hudu synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Folder ID.</param>
    /// <param name="body">The request body containing the fields to update.</param>
    /// <returns>The updated <see cref="HuduFolder"/>.</returns>
    public HuduFolder UpdateFolder(int id, object body) => Sync(UpdateFolderAsync(id, body));

    /// <summary>
    /// Updates an existing Folder in Hudu asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Folder ID.</param>
    /// <param name="body">The request body containing the fields to update.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the updated <see cref="HuduFolder"/>.</returns>
    public async Task<HuduFolder> UpdateFolderAsync(int id, object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/folders/{1}", ApiRoot, id);

        var wrapper = new
        {
            folder = body
        };

        return await PutAsync<HuduFolder>(path, wrapper, itemsProperty: "folder", ct: cancellationToken);
    }

    /// <summary>
    /// Deletes a Folder from Hudu synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Folder ID.</param>
    public void DeleteFolder(int id) => Sync(DeleteFolderAsync(id));

    /// <summary>
    /// Deletes a Folder from Hudu asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Folder ID.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task that completes when the Folder has been deleted.</returns>
    public async Task DeleteFolderAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/folders/{1}", ApiRoot, id);
        _ = await DeleteAsync<HuduFolder>(path, itemsProperty: "folder", ct: cancellationToken);
    }
}
