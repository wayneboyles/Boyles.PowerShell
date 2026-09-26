using System.Collections.ObjectModel;
using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Partial class containing Hudu flag type-related API operations.
    /// </summary>
    public partial class HuduClient
    {
        /// <summary>
        /// Retrieves a single flag type by its ID synchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu flag type ID.</param>
        /// <returns>The matching <see cref="HuduFlagType"/>.</returns>
        public HuduFlagType GetFlagType(int id) => Sync(GetFlagTypeAsync(id));

        /// <summary>
        /// Retrieves a single flag type by its ID asynchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu flag type ID.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the matching <see cref="HuduFlagType"/>.</returns>
        public async Task<HuduFlagType> GetFlagTypeAsync(int id, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/flag_types/{1}", ApiRoot, id);
            return await GetAsync<HuduFlagType>(path, itemsProperty: "flag_type", ct: cancellationToken);
        }

        /// <summary>
        /// Retrieves all flag types from the Hudu API synchronously, following pagination.
        /// </summary>
        /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
        /// <returns>A list of all matching <see cref="HuduFlagType"/> records.</returns>
        public List<HuduFlagType> GetFlagTypes(Dictionary<string, string>? query = null) => Sync(GetFlagTypesAsync(query));

        /// <summary>
        /// Retrieves all flag types from the Hudu API asynchronously, following pagination.
        /// </summary>
        /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to a list of all matching <see cref="HuduFlagType"/> records.</returns>
        public async Task<List<HuduFlagType>> GetFlagTypesAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/flag_types", ApiRoot);

            var queryParams = new ReadOnlyDictionary<string, string>(query ?? new Dictionary<string, string>());

            return await GetAllPagesAsync<HuduFlagType>(path, queryParams, itemsProperty: "flag_types", offsetParam: "page", limitParam: "page_size", ct: cancellationToken);
        }

        /// <summary>
        /// Creates a new flag type in Hudu synchronously.
        /// </summary>
        /// <param name="body">The request body representing the flag type to create.</param>
        /// <returns>The newly created <see cref="HuduFlagType"/>.</returns>
        public HuduFlagType NewFlagType(object body) => Sync(NewFlagTypeAsync(body));

        /// <summary>
        /// Creates a new flag type in Hudu asynchronously.
        /// </summary>
        /// <param name="body">The request body representing the flag type to create.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the newly created <see cref="HuduFlagType"/>.</returns>
        public async Task<HuduFlagType> NewFlagTypeAsync(object body, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/flag_types", ApiRoot);
            return await PostAsync<HuduFlagType>(path, body, itemsProperty: "flag_type", ct: cancellationToken);
        }

        /// <summary>
        /// Updates an existing flag type in Hudu synchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu flag type ID.</param>
        /// <param name="body">
        /// The fields to update. Wrapped in a <c>flag_type</c> envelope before sending.
        /// </param>
        /// <returns>The updated <see cref="HuduFlagType"/>.</returns>
        public HuduFlagType UpdateFlagType(int id, object body) => Sync(UpdateFlagTypeAsync(id, body));

        /// <summary>
        /// Updates an existing flag type in Hudu asynchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu flag type ID.</param>
        /// <param name="body">
        /// The fields to update. Wrapped in a <c>flag_type</c> envelope before sending.
        /// </param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the updated <see cref="HuduFlagType"/>.</returns>
        public async Task<HuduFlagType> UpdateFlagTypeAsync(int id, object body, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/flag_types/{1}", ApiRoot, id);

            var wrapper = new
            {
                flag_type = body
            };

            return await PutAsync<HuduFlagType>(path, wrapper, itemsProperty: "flag_type", ct: cancellationToken);
        }

        /// <summary>
        /// Deletes a flag type from Hudu synchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu flag type ID.</param>
        public void DeleteFlagType(int id) => Sync(DeleteFlagTypeAsync(id));

        /// <summary>
        /// Deletes a flag type from Hudu asynchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu flag type ID.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task that completes when the flag type has been deleted.</returns>
        public async Task DeleteFlagTypeAsync(int id, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/flag_types/{1}", ApiRoot, id);
            _ = await DeleteAsync<HuduFlagType>(path, ct: cancellationToken);
        }
    }
}
