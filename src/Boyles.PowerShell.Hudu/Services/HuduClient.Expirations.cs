using System.Collections.ObjectModel;
using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Partial class containing Hudu expiration-related API operations.
    /// </summary>
    public partial class HuduClient
    {
        /// <summary>
        /// Retrieves all expirations from the Hudu API synchronously, following pagination.
        /// </summary>
        /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
        /// <returns>A list of all matching <see cref="HuduExpiration"/> records.</returns>
        public List<HuduExpiration> GetExpirations(IDictionary<string, string>? query = null) => Sync(GetExpirationsAsync(query));

        /// <summary>
        /// Retrieves all expirations from the Hudu API asynchronously, following pagination.
        /// </summary>
        /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to a list of all matching <see cref="HuduExpiration"/> records.</returns>
        public async Task<List<HuduExpiration>> GetExpirationsAsync(IDictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/expirations", ApiRoot);
            
            var queryParams = new ReadOnlyDictionary<string, string>(query ?? new Dictionary<string, string>());
            
            return await GetAllPagesAsync<HuduExpiration>(path, queryParams, itemsProperty: "expirations", offsetParam: "page", limitParam: "page_size", ct: cancellationToken);
        }

        /// <summary>
        /// Updates an existing expiration in Hudu synchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu expiration ID.</param>
        /// <param name="body">The request body containing the fields to update.</param>
        /// <returns>The updated <see cref="HuduExpiration"/>.</returns>
        public HuduExpiration UpdateExpiration(int id, object? body = null) => Sync(UpdateExpirationAsync(id, body));

        /// <summary>
        /// Updates an existing expiration in Hudu asynchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu expiration ID.</param>
        /// <param name="body">The request body containing the fields to update.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the updated <see cref="HuduExpiration"/>.</returns>
        public async Task<HuduExpiration> UpdateExpirationAsync(int id, object? body = null, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/expirations/{1}", ApiRoot, id);

            var bodyObject = new
            {
                expiration = body
            };
            
            return await PutAsync<HuduExpiration>(path, bodyObject, "expiration", ct: cancellationToken);
        }

        /// <summary>
        /// Deletes an expiration from Hudu synchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu expiration ID.</param>
        public void DeleteExpiration(int id) => Sync(DeleteExpirationAsync(id));

        /// <summary>
        /// Deletes an expiration from Hudu asynchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu expiration ID.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task that completes when the expiration has been deleted.</returns>
        public async Task DeleteExpirationAsync(int id, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/expirations/{1}", ApiRoot, id);
            await DeleteAsync<HuduExpiration>(path, ct: cancellationToken);
        }
    }
} 