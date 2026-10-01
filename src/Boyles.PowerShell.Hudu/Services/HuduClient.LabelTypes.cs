using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Partial class containing Hudu Label type-related API operations.
    /// </summary>
    public partial class HuduClient
    {
        /// <summary>
        /// Retrieves a single Label type by its ID synchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu Label type ID.</param>
        /// <returns>The matching <see cref="HuduLabelType"/>.</returns>
        public HuduLabelType GetLabelType(int id) => Sync(GetLabelTypeAsync(id));

        /// <summary>
        /// Retrieves a single Label type by its ID asynchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu Label type ID.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the matching <see cref="HuduLabelType"/>.</returns>
        public async Task<HuduLabelType> GetLabelTypeAsync(int id, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/label_types/{1}", ApiRoot, id);
            return await GetAsync<HuduLabelType>(path, itemsProperty: "label_type", ct: cancellationToken);
        }

        /// <summary>
        /// Retrieves all Label types from the Hudu API synchronously, following pagination.
        /// </summary>
        /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
        /// <returns>A list of all matching <see cref="HuduLabelType"/> records.</returns>
        public List<HuduLabelType> GetLabelTypes(Dictionary<string, string>? query = null) => Sync(GetLabelTypesAsync(query));

        /// <summary>
        /// Retrieves all Label types from the Hudu API asynchronously, following pagination.
        /// </summary>
        /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to a list of all matching <see cref="HuduLabelType"/> records.</returns>
        public async Task<List<HuduLabelType>> GetLabelTypesAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/label_types", ApiRoot);

            return await GetAllHuduPagesAsync<HuduLabelType>(path, query, "label_types", cancellationToken);
        }

        /// <summary>
        /// Creates a new Label type in Hudu synchronously.
        /// </summary>
        /// <param name="body">The request body representing the Label type to create.</param>
        /// <returns>The newly created <see cref="HuduLabelType"/>.</returns>
        public HuduLabelType NewLabelType(object body) => Sync(NewLabelTypeAsync(body));

        /// <summary>
        /// Creates a new Label type in Hudu asynchronously.
        /// </summary>
        /// <param name="body">The request body representing the Label type to create.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the newly created <see cref="HuduLabelType"/>.</returns>
        public async Task<HuduLabelType> NewLabelTypeAsync(object body, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/label_types", ApiRoot);
            return await PostAsync<HuduLabelType>(path, body, itemsProperty: "label_type", ct: cancellationToken);
        }

        /// <summary>
        /// Updates an existing Label type in Hudu synchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu Label type ID.</param>
        /// <param name="body">
        /// The fields to update. Wrapped in a <c>Label_type</c> envelope before sending.
        /// </param>
        /// <returns>The updated <see cref="HuduLabelType"/>.</returns>
        public HuduLabelType UpdateLabelType(int id, object body) => Sync(UpdateLabelTypeAsync(id, body));

        /// <summary>
        /// Updates an existing Label type in Hudu asynchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu Label type ID.</param>
        /// <param name="body">
        /// The fields to update. Wrapped in a <c>Label_type</c> envelope before sending.
        /// </param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the updated <see cref="HuduLabelType"/>.</returns>
        public async Task<HuduLabelType> UpdateLabelTypeAsync(int id, object body, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/label_types/{1}", ApiRoot, id);

            var wrapper = new
            {
                label_type = body
            };

            return await PutAsync<HuduLabelType>(path, wrapper, itemsProperty: "label_type", ct: cancellationToken);
        }

        /// <summary>
        /// Deletes a Label type from Hudu synchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu Label type ID.</param>
        public void DeleteLabelType(int id) => Sync(DeleteLabelTypeAsync(id));

        /// <summary>
        /// Deletes a Label type from Hudu asynchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu Label type ID.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task that completes when the Label type has been deleted.</returns>
        public async Task DeleteLabelTypeAsync(int id, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/label_types/{1}", ApiRoot, id);
            _ = await DeleteAsync<HuduLabelType>(path, ct: cancellationToken);
        }
    }
}
