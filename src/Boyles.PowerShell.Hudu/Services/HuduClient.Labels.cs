using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services;

/// <summary>
/// Partial class containing Hudu Label-related API operations.
/// </summary>
public partial class HuduClient
{
    /// <summary>
    /// Retrieves a single Label by its ID synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Label ID.</param>
    /// <returns>The matching <see cref="HuduLabel"/>.</returns>
    public HuduLabel GetLabel(int id) => Sync(GetLabelAsync(id));

    /// <summary>
    /// Retrieves a single Label by its ID asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Label ID.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the matching <see cref="HuduLabel"/>.</returns>
    public async Task<HuduLabel> GetLabelAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/labels/{1}", ApiRoot, id);
        return await GetAsync<HuduLabel>(path, itemsProperty: "label", ct: cancellationToken);
    }

    /// <summary>
    /// Retrieves all Labels from the Hudu API synchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <returns>A list of all matching <see cref="HuduLabel"/> records.</returns>
    public List<HuduLabel> GetLabels(Dictionary<string, string>? query = null) => Sync(GetLabelsAsync(query));

    /// <summary>
    /// Retrieves all Labels from the Hudu API asynchronously, following pagination.
    /// </summary>
    /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to a list of all matching <see cref="HuduLabel"/> records.</returns>
    public async Task<List<HuduLabel>> GetLabelsAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/labels", ApiRoot);
        return await GetAllHuduPagesAsync<HuduLabel>(path, query, "labels", cancellationToken);
    }

    /// <summary>
    /// Creates a new Label in Hudu synchronously.
    /// </summary>
    /// <param name="body">
    /// The request body representing the Label to create. Wrapped in a <c>label</c> envelope before sending.
    /// </param>
    /// <returns>The newly created <see cref="HuduLabel"/>.</returns>
    public HuduLabel NewLabel(object body) => Sync(NewLabelAsync(body));
    
    /// <summary>
    /// Creates a new Label in Hudu asynchronously.
    /// </summary>
    /// <param name="body">
    /// The request body representing the Label to create. Wrapped in a <c>label</c> envelope before sending.
    /// </param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the newly created <see cref="HuduLabel"/>.</returns>
    public async Task<HuduLabel> NewLabelAsync(object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/labels", ApiRoot);

        var wrapper = new
        {
            Label = body
        };

        return await PostAsync<HuduLabel>(path, wrapper, itemsProperty: "label", ct: cancellationToken);
    }

    /// <summary>
    /// Updates an existing Label in Hudu synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Label ID.</param>
    /// <param name="body">The request body containing the fields to update.</param>
    /// <returns>The updated <see cref="HuduLabel"/>.</returns>
    public HuduLabel UpdateLabel(int id, object body) => Sync(UpdateLabelAsync(id, body));

    /// <summary>
    /// Updates an existing Label in Hudu asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Label ID.</param>
    /// <param name="body">The request body containing the fields to update.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task resolving to the updated <see cref="HuduLabel"/>.</returns>
    public async Task<HuduLabel> UpdateLabelAsync(int id, object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/labels/{1}", ApiRoot, id);
        
        var wrapper = new
        {
            label = body
        };
        
        return await PutAsync<HuduLabel>(path, wrapper, itemsProperty: "label", ct: cancellationToken);
    }

    /// <summary>
    /// Deletes a Label from Hudu synchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Label ID.</param>
    public void DeleteLabel(int id) => Sync(DeleteLabelAsync(id));

    /// <summary>
    /// Deletes a Label from Hudu asynchronously.
    /// </summary>
    /// <param name="id">The numeric Hudu Label ID.</param>
    /// <param name="cancellationToken">Token to cancel the request.</param>
    /// <returns>A task that completes when the Label has been deleted.</returns>
    public async Task DeleteLabelAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/labels/{1}", ApiRoot, id);
        _ = await DeleteAsync<HuduLabel>(path, itemsProperty: "label", ct: cancellationToken);
    }
}
