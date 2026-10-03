using System.Globalization;

using Boyles.PowerShell.Hudu.Builders;
using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services;

/// <summary>
/// Partial class containing Hudu List-related API operations.
/// </summary>
public partial class HuduClient
{
    /// <summary>
    /// Retrieves a single List by its ID synchronously.
    /// </summary>
    /// <param name="id">The unique identifier of the List to retrieve.</param>
    /// <returns>The matching <see cref="HuduList"/>.</returns>
    public HuduList GetList(int id) => Sync(GetListAsync(id));

    /// <summary>
    /// Retrieves a single List by its ID asynchronously.
    /// </summary>
    /// <param name="id">The unique identifier of the List to retrieve.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the matching <see cref="HuduList"/>.</returns>
    public async Task<HuduList> GetListAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/lists/{1}", ApiRoot, id);
        return await GetAsync<HuduList>(path, ct: cancellationToken);
    }

    /// <summary>
    /// Retrieves all Lists from the Hudu API synchronously in a single request.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <returns>A list of all matching <see cref="HuduList"/> records.</returns>
    public List<HuduList> GetLists(Dictionary<string, string>? query = null) => Sync(GetListsAsync(query));

    /// <summary>
    /// Retrieves all Lists from the Hudu API asynchronously in a single request.
    /// </summary>
    /// <remarks>
    /// Unlike most Hudu list endpoints, <c>/lists</c> ignores <c>page</c>/<c>page_size</c> and returns
    /// every list as a bare JSON array, so it is fetched directly rather than through
    /// <see cref="GetAllHuduPagesAsync{T}"/>.
    /// </remarks>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to a list of all matching <see cref="HuduList"/> records.</returns>
    public async Task<List<HuduList>> GetListsAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/lists", ApiRoot);

        // No itemsProperty: the response is a bare array, and an envelope name would make
        // DeserializeBody look for a property on an object that isn't there and return null.
        var lists = await GetAsync<List<HuduList>>(path, query, ct: cancellationToken);
        return lists ?? new List<HuduList>();
    }

    /// <summary>
    /// Creates a new List in Hudu synchronously.
    /// </summary>
    /// <param name="body">
    /// The request body representing the List to create. Wrapped in a <c>list</c> envelope before sending.
    /// </param>
    /// <param name="fields">The list item values.</param>
    /// <returns>The newly created <see cref="HuduList"/>.</returns>
    public HuduList NewList(object body, HuduListItem[] fields) => Sync(NewListAsync(body, fields));

    /// <summary>
    /// Creates a new List in Hudu asynchronously.
    /// </summary>
    /// <param name="body">
    /// The request body representing the List to create. Wrapped in a <c>list</c> envelope before sending.
    /// </param>
    /// <param name="fields">The list item values.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the newly created <see cref="HuduList"/>.</returns>
    public async Task<HuduList> NewListAsync(object body, HuduListItem[] fields, CancellationToken cancellationToken = default)
    {
        var wrapper = HuduRequestBuilder.BuildListJson(body, fields);
        
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/lists", ApiRoot);

        return await PostAsync<HuduList>(path, wrapper, ct: cancellationToken);
    }

    /// <summary>
    /// Updates an existing List in Hudu synchronously.
    /// </summary>
    /// <param name="id">The unique identifier of the List to update.</param>
    /// <param name="body">The request body containing the fields to update.</param>
    /// <param name="fields">The list item values.</param>
    /// <returns>The updated <see cref="HuduList"/>.</returns>
    public HuduList UpdateList(int id, object body, HuduListItem[]? fields = null) => Sync(UpdateListAsync(id, body, fields));

    /// <summary>
    /// Updates an existing List in Hudu asynchronously.
    /// </summary>
    /// <param name="id">The unique identifier of the List to update.</param>
    /// <param name="body">The request body containing the fields to update.</param>
    /// <param name="fields">The list item values.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the updated <see cref="HuduList"/>.</returns>
    public async Task<HuduList> UpdateListAsync(int id, object body, HuduListItem[]? fields = null, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/lists/{1}", ApiRoot, id);

        var wrapper = HuduRequestBuilder.BuildListJson(body, fields);
        
        return await PutAsync<HuduList>(path, wrapper, ct: cancellationToken);
    }

    /// <summary>
    /// Deletes a List from Hudu synchronously.
    /// </summary>
    /// <param name="id">The unique identifier of the List to delete.</param>
    public void DeleteList(int id) => Sync(DeleteListAsync(id));

    /// <summary>
    /// Deletes a List from Hudu asynchronously.
    /// </summary>
    /// <param name="id">The unique identifier of the List to delete.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task that completes when the List has been deleted.</returns>
    public async Task DeleteListAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/lists/{1}", ApiRoot, id);
        _ = await DeleteAsync<HuduList>(path, ct: cancellationToken);
    }
}
