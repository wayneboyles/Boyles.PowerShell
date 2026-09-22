using System.Globalization;

using Boyles.PowerShell.Hudu.Builders;
using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Partial class containing Hudu asset-related API operations.
    /// </summary>
    public partial class HuduClient
    {
        /// <summary>
        /// Retrieves all assets from the Hudu API synchronously.
        /// </summary>
        /// <param name="query">Optional query string parameters used to filter the results.</param>
        /// <returns>A list of all matching <see cref="HuduAsset"/> records.</returns>
        public List<HuduAsset> GetAssets(Dictionary<string, string>? query = null) => Sync(GetAssetsAsync(query));

        /// <summary>
        /// Retrieves all assets from the Hudu API asynchronously.
        /// </summary>
        /// <param name="query">Optional query string parameters used to filter the results.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to a list of all matching <see cref="HuduAsset"/> records.</returns>
        public async Task<List<HuduAsset>> GetAssetsAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/assets", ApiRoot);
            return await GetAllPagesAsync<HuduAsset>(path, query, itemsProperty: "assets", offsetParam: "page", limitParam: "page_size");
        }

        /// <summary>
        /// Retrieves all assets belonging to a specific company synchronously, using the
        /// lighter company-scoped list endpoint.
        /// </summary>
        /// <param name="companyId">The unique identifier of the company whose assets should be retrieved.</param>
        /// <param name="query">Optional query string parameters used to filter the results.</param>
        /// <returns>A list of matching <see cref="HuduAsset"/> records for the given company.</returns>
        public List<HuduAsset> GetAssetsForCompany(int companyId, Dictionary<string, string>? query = null) => Sync(GetAssetsForCompanyAsync(companyId, query));

        /// <summary>
        /// Retrieves all assets belonging to a specific company asynchronously, using the
        /// lighter company-scoped list endpoint.
        /// </summary>
        /// <param name="companyId">The unique identifier of the company whose assets should be retrieved.</param>
        /// <param name="query">Optional query string parameters used to filter the results.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to a list of matching <see cref="HuduAsset"/> records for the given company.</returns>
        public async Task<List<HuduAsset>> GetAssetsForCompanyAsync(int companyId, Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/assets", ApiRoot, companyId);
            return await GetAllPagesAsync<HuduAsset>(path, query, itemsProperty: "assets", limitParam: "page_size", offsetParam: "page", ct: cancellationToken);
        }

        /// <summary>
        /// Retrieves a single asset by its ID, scoped to its owning company, synchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu asset ID.</param>
        /// <param name="companyId">The unique identifier of the company the asset belongs to.</param>
        /// <returns>The matching <see cref="HuduAsset"/>.</returns>
        public HuduAsset GetAsset(int id, int companyId) => Sync(GetAssetAsync(id, companyId));

        /// <summary>
        /// Retrieves a single asset by its ID, scoped to its owning company, asynchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu asset ID.</param>
        /// <param name="companyId">The unique identifier of the company the asset belongs to.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the matching <see cref="HuduAsset"/>.</returns>
        public async Task<HuduAsset> GetAssetAsync(int id, int companyId, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/assets/{2}", ApiRoot, companyId, id);
            return await GetAsync<HuduAsset>(path, null, itemsProperty: "asset", ct: cancellationToken);
        }

        /// <summary>
        /// Synchronously creates a new asset in Hudu.
        /// </summary>
        /// <param name="companyId">The unique identifier of the company to create the asset under.</param>
        /// <param name="body">The request body representing the asset's top-level properties to create.</param>
        /// <param name="fields">The asset's field values, keyed to the asset layout's field definitions.</param>
        /// <returns>The newly created <see cref="HuduAsset"/>.</returns>
        public HuduAsset NewAsset(int companyId, object body, HuduAssetField[] fields) => Sync(NewAssetAsync(companyId, body, fields));

        /// <summary>
        /// Asynchronously creates a new asset in Hudu.
        /// </summary>
        /// <param name="companyId">The unique identifier of the company to create the asset under.</param>
        /// <param name="body">The request body representing the asset's top-level properties to create.</param>
        /// <param name="fields">The asset's field values, keyed to the asset layout's field definitions.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>A task that resolves to the newly created <see cref="HuduAsset"/>.</returns>
        public async Task<HuduAsset> NewAssetAsync(int companyId, object body, HuduAssetField[] fields, CancellationToken cancellationToken = default)
        {
            var wrapper = HuduRequestBuilder.BuildAssetJson(body, fields);

            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/assets", ApiRoot, companyId);

            return await PostAsync<HuduAsset>(path, wrapper, "asset", cancellationToken);
        }

        /// <summary>
        /// Synchronously updates an existing asset in Hudu.
        /// </summary>
        /// <param name="id">The unique identifier of the asset to update.</param>
        /// <param name="companyId">The unique identifier of the company the asset belongs to.</param>
        /// <param name="body">The request body representing the asset's top-level properties to update.</param>
        /// <param name="fields">The asset's field values to write, keyed to the asset layout's field definitions.</param>
        /// <returns>The updated <see cref="HuduAsset"/>.</returns>
        public HuduAsset UpdateAsset(int id, int companyId, object body, HuduAssetField[]? fields = null) => Sync(UpdateAssetAsync(id, companyId, body, fields));

        /// <summary>
        /// Asynchronously updates an existing asset in Hudu.
        /// </summary>
        /// <param name="id">The unique identifier of the asset to update.</param>
        /// <param name="companyId">The unique identifier of the company the asset belongs to.</param>
        /// <param name="body">The request body representing the asset's top-level properties to update.</param>
        /// <param name="fields">The asset's field values to write, keyed to the asset layout's field definitions.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>A task that resolves to the updated <see cref="HuduAsset"/>.</returns>
        public async Task<HuduAsset> UpdateAssetAsync(int id, int companyId, object body, HuduAssetField[]? fields = null, CancellationToken cancellationToken = default)
        {
            var wrapper = HuduRequestBuilder.BuildAssetJson(body, fields);

            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/assets/{2}", ApiRoot, companyId, id);

            return await PutAsync<HuduAsset>(path, wrapper, "asset", cancellationToken);
        }

        /// <summary>
        /// Synchronously deletes an asset.
        /// </summary>
        /// <param name="id">The unique identifier of the asset to delete.</param>
        /// <param name="companyId">The unique identifier of the company the asset belongs to.</param>
        public void DeleteAsset(int id, int companyId) => Sync(DeleteAssetAsync(id, companyId));

        /// <summary>
        /// Asynchronously deletes an asset.
        /// </summary>
        /// <param name="id">The unique identifier of the asset to delete.</param>
        /// <param name="companyId">The unique identifier of the company the asset belongs to.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>A task that represents the asynchronous delete operation.</returns>
        public async Task DeleteAssetAsync(int id, int companyId, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/assets/{2}", ApiRoot, companyId, id);
            await DeleteAsync<HuduAsset>(path, ct: cancellationToken);
        }

        /// <summary>
        /// Archives an asset record in Hudu, marking it as inactive.
        /// </summary>
        /// <param name="id">The unique identifier of the asset to archive.</param>
        /// <param name="companyId">The unique identifier of the company the asset belongs to.</param>
        /// <returns>The updated <see cref="HuduAsset"/> reflecting the archived state.</returns>
        public HuduAsset ArchiveAsset(int id, int companyId) => Sync(ArchiveAssetAsync(id, companyId));

        /// <summary>
        /// Asynchronously archives an asset record in Hudu, marking it as inactive.
        /// </summary>
        /// <param name="id">The unique identifier of the asset to archive.</param>
        /// <param name="companyId">The unique identifier of the company the asset belongs to.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>A task that resolves to the updated <see cref="HuduAsset"/> reflecting the archived state.</returns>
        public async Task<HuduAsset> ArchiveAssetAsync(int id, int companyId, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/assets/{2}/archive", ApiRoot, companyId, id);
            return await PutAsync<HuduAsset>(path, null, "asset", cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Synchronously unarchives an asset.
        /// </summary>
        /// <param name="id">The unique identifier of the asset to unarchive.</param>
        /// <param name="companyId">The unique identifier of the company the asset belongs to.</param>
        /// <returns>The updated <see cref="HuduAsset"/> after unarchiving.</returns>
        public HuduAsset UnarchiveAsset(int id, int companyId) => Sync(UnarchiveAssetAsync(id, companyId));

        /// <summary>
        /// Asynchronously unarchives an asset.
        /// </summary>
        /// <param name="id">The unique identifier of the asset to unarchive.</param>
        /// <param name="companyId">The unique identifier of the company the asset belongs to.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>
        /// A task that represents the asynchronous operation.
        /// The task result contains the updated <see cref="HuduAsset"/> after unarchiving.
        /// </returns>
        public async Task<HuduAsset> UnarchiveAssetAsync(int id, int companyId, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/assets/{2}/unarchive", ApiRoot, companyId, id);
            return await PutAsync<HuduAsset>(path, null, "asset", cancellationToken).ConfigureAwait(false);
        }
    }
}
