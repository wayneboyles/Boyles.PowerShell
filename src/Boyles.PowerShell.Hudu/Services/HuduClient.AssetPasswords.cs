using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Partial class containing Hudu assetPassword-related API operations.
    /// </summary>
    public partial class HuduClient
    {
        /// <summary>
        /// Retrieves all AssetPasswords matching the given filters synchronously, automatically
        /// paging through the full result set.
        /// </summary>
        /// <param name="query">Optional query parameters to filter or scope the request.</param>
        /// <returns>A list of all <see cref="HuduAssetPassword"/> records.</returns>
        public List<HuduAssetPassword> GetAssetPasswords(Dictionary<string, string>? query = null) => Sync(GetAssetPasswordsAsync(query));

        /// <summary>
        /// Retrieves all AssetPasswords matching the given filters asynchronously, automatically
        /// paging through the full result set.
        /// </summary>
        /// <param name="query">Optional query parameters to filter or scope the request.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to a list of all <see cref="HuduAssetPassword"/> records.</returns>
        public async Task<List<HuduAssetPassword>> GetAssetPasswordsAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_passwords", ApiRoot);
            return await GetAllPagesAsync<HuduAssetPassword>(path, query, offsetParam: "page", limitParam: "page_size", itemsProperty: "asset_passwords", ct: cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Retrieves a single AssetPassword by its ID synchronously.
        /// </summary>
        /// <param name="Id">The unique identifier of the AssetPassword to retrieve.</param>
        /// <returns>The matching <see cref="HuduAssetPassword"/>, or <c>null</c> if not found.</returns>
        public HuduAssetPassword GetAssetPassword(int Id) => Sync(GetAssetPasswordAsync(Id));

        /// <summary>
        /// Retrieves a single AssetPassword by its ID asynchronously.
        /// </summary>
        /// <param name="Id">The unique identifier of the AssetPassword to retrieve.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the matching <see cref="HuduAssetPassword"/>, or <c>null</c> if not found.</returns>
        public async Task<HuduAssetPassword> GetAssetPasswordAsync(int Id, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_passwords/{1}", ApiRoot, Id);
            return await GetAsync<HuduAssetPassword>(path, null, "asset_password", cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Creates a new AssetPassword record in Hudu synchronously.
        /// </summary>
        /// <param name="body">
        /// The request body representing the AssetPassword to create.
        /// </param>
        /// <returns>The newly created <see cref="HuduAssetPassword"/>.</returns>
        public HuduAssetPassword NewAssetPassword(object body) => Sync(NewAssetPasswordAsync(body));

        /// <summary>
        /// Asynchronously creates a new AssetPassword record in Hudu.
        /// </summary>
        /// <param name="body">
        /// The request body representing the AssetPassword to create.
        /// </param>
        /// <param name="cancellationToken">
        /// A token to monitor for cancellation requests.
        /// </param>
        /// <returns>
        /// A task that resolves to the newly created <see cref="HuduAssetPassword"/>.
        /// </returns>
        public async Task<HuduAssetPassword> NewAssetPasswordAsync(object body, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_passwords", ApiRoot);
            return await PostAsync<HuduAssetPassword>(path, body, "asset_password", cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Synchronously updates a AssetPassword.
        /// </summary>
        /// <param name="Id">The unique identifier of the AssetPassword to update.</param>
        /// <param name="body">The request body containing the updated data.</param>
        /// <returns>The updated <see cref="HuduAssetPassword"/>.</returns>
        public HuduAssetPassword UpdateAssetPassword(int Id, object body) => Sync(UpdateAssetPasswordAsync(Id, body));

        /// <summary>
        /// Asynchronously updates a AssetPassword.
        /// </summary>
        /// <param name="Id">The unique identifier of the AssetPassword to update.</param>
        /// <param name="body">The request body containing the updated data.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>
        /// A task that represents the asynchronous operation.
        /// The task result contains the updated <see cref="HuduAssetPassword"/>.
        /// </returns>
        public async Task<HuduAssetPassword> UpdateAssetPasswordAsync(int Id, object body, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_passwords/{1}", ApiRoot, Id);
            return await PutAsync<HuduAssetPassword>(path, body, "asset_password", cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Synchronously deletes a AssetPassword.
        /// </summary>
        /// <param name="Id">The unique identifier of the AssetPassword to delete.</param>
        public void DeleteAssetPassword(int Id) => Sync(DeleteAssetPasswordAsync(Id));

        /// <summary>
        /// Asynchronously deletes a AssetPassword.
        /// </summary>
        /// <param name="Id">The unique identifier of the AssetPassword to delete.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>A task that represents the asynchronous delete operation.</returns>
        public async Task DeleteAssetPasswordAsync(int Id, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_passwords/{1}", ApiRoot, Id);
            await DeleteAsync<HuduAssetPassword>(path, null, cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Retrieves a single specific page of AssetPasswords synchronously, without paging further.
        /// </summary>
        /// <param name="query">Optional filter parameters merged into the request alongside page and page_size.</param>
        /// <param name="page">The 1-based page number to retrieve.</param>
        /// <param name="pageSize">The number of items requested per page.</param>
        /// <returns>The single page of matching <see cref="HuduAssetPassword"/> records, as returned by the API.</returns>
        public List<HuduAssetPassword> GetAssetPasswordsPage(Dictionary<string, string>? query, int page, int pageSize) => Sync(GetAssetPasswordsPageAsync(query, page, pageSize));

        /// <summary>
        /// Retrieves a single specific page of AssetPasswords asynchronously, without paging further.
        /// Use this instead of <see cref="GetAssetPasswordsAsync"/> when the caller has explicitly
        /// requested a page and page size rather than the full result set.
        /// </summary>
        /// <param name="query">Optional filter parameters merged into the request alongside page and page_size.</param>
        /// <param name="page">The 1-based page number to retrieve.</param>
        /// <param name="pageSize">The number of items requested per page.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the single page of matching <see cref="HuduAssetPassword"/> records, as returned by the API.</returns>
        public async Task<List<HuduAssetPassword>> GetAssetPasswordsPageAsync(Dictionary<string, string>? query, int page, int pageSize, CancellationToken cancellationToken = default)
        {
            var q = new Dictionary<string, string>(query ?? new Dictionary<string, string>(), StringComparer.Ordinal)
            {
                ["page"] = page.ToString(CultureInfo.InvariantCulture),
                ["page_size"] = pageSize.ToString(CultureInfo.InvariantCulture)
            };

            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_passwords", ApiRoot);
            return await GetAsync<List<HuduAssetPassword>>(path, q, itemsProperty: "asset_passwords", ct: cancellationToken);
        }

        public HuduAssetPassword ArchiveAssetPassword(int id) => Sync(ArchiveAssetPasswordAsync(id));

        public async Task<HuduAssetPassword> ArchiveAssetPasswordAsync(int id, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_passwords/{1}/archive", ApiRoot, id);
            return await PutAsync<HuduAssetPassword>(path, null, "asset_password", cancellationToken).ConfigureAwait(false);
        }

        public HuduAssetPassword UnarchiveAssetPassword(int id) => Sync(UnarchiveAssetPasswordAsync(id));

        public async Task<HuduAssetPassword> UnarchiveAssetPasswordAsync(int id, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_passwords/{1}/unarchive", ApiRoot, id);
            return await PutAsync<HuduAssetPassword>(path, null, "asset_password", cancellationToken).ConfigureAwait(false);
        }
    }
}
