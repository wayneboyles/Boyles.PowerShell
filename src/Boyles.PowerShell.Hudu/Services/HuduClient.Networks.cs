using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Partial class containing Hudu Network-related API operations.
    /// </summary>
    public partial class HuduClient
    {
        /// <summary>
        /// Retrieves a single Network by its ID synchronously.
        /// </summary>
        /// <param name="id">The unique identifier of the Network to retrieve.</param>
        /// <returns>The matching <see cref="HuduNetwork"/>.</returns>
        public HuduNetwork GetNetwork(int id) => Sync(GetNetworkAsync(id));

        /// <summary>
        /// Retrieves a single Network by its ID asynchronously.
        /// </summary>
        /// <param name="id">The unique identifier of the Network to retrieve.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the matching <see cref="HuduNetwork"/>.</returns>
        public async Task<HuduNetwork> GetNetworkAsync(int id, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/networks/{1}", ApiRoot, id);
            return await GetAsync<HuduNetwork>(path, itemsProperty: "network", ct: cancellationToken);
        }

        /// <summary>
        /// Retrieves all Networks from the Hudu API synchronously, following pagination.
        /// </summary>
        /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
        /// <returns>A list of all matching <see cref="HuduNetwork"/> records.</returns>
        public List<HuduNetwork> GetNetworks(Dictionary<string, string>? query = null) => Sync(GetNetworksAsync(query));

        /// <summary>
        /// Retrieves all Networks from the Hudu API asynchronously, following pagination.
        /// </summary>
        /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to a list of all matching <see cref="HuduNetwork"/> records.</returns>
        public async Task<List<HuduNetwork>> GetNetworksAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/networks", ApiRoot);
            return await GetAsync<List<HuduNetwork>>(path, query, ct: cancellationToken);
        }

        /// <summary>
        /// Creates a new Network in Hudu synchronously.
        /// </summary>
        /// <param name="body">
        /// The request body representing the Network to create. Wrapped in a <c>network</c> envelope before sending.
        /// </param>
        /// <returns>The newly created <see cref="HuduNetwork"/>.</returns>
        public HuduNetwork NewNetwork(object body) => Sync(NewNetworkAsync(body));

        /// <summary>
        /// Creates a new Network in Hudu asynchronously.
        /// </summary>
        /// <param name="body">
        /// The request body representing the Network to create. Wrapped in a <c>network</c> envelope before sending.
        /// </param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the newly created <see cref="HuduNetwork"/>.</returns>
        public async Task<HuduNetwork> NewNetworkAsync(object body, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/networks", ApiRoot);

            var wrapper = new
            {
                network = body
            };

            return await PostAsync<HuduNetwork>(path, wrapper, ct: cancellationToken);
        }

        /// <summary>
        /// Updates an existing Network in Hudu synchronously.
        /// </summary>
        /// <param name="id">The unique identifier of the Network to update.</param>
        /// <param name="body">The request body containing the fields to update.</param>
        /// <returns>The updated <see cref="HuduNetwork"/>.</returns>
        public HuduNetwork UpdateNetwork(int id, object body) => Sync(UpdateNetworkAsync(id, body));

        /// <summary>
        /// Updates an existing Network in Hudu asynchronously.
        /// </summary>
        /// <param name="id">The unique identifier of the Network to update.</param>
        /// <param name="body">The request body containing the fields to update.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the updated <see cref="HuduNetwork"/>.</returns>
        public async Task<HuduNetwork> UpdateNetworkAsync(int id, object body, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/networks/{1}", ApiRoot, id);

            var wrapper = new
            {
                network = body
            };

            return await PutAsync<HuduNetwork>(path, wrapper, ct: cancellationToken);
        }

        /// <summary>
        /// Deletes a Network from Hudu synchronously.
        /// </summary>
        /// <param name="id">The unique identifier of the Network to delete.</param>
        public void DeleteNetwork(int id) => Sync(DeleteNetworkAsync(id));

        /// <summary>
        /// Deletes a Network from Hudu asynchronously.
        /// </summary>
        /// <param name="id">The unique identifier of the Network to delete.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task that completes when the Network has been deleted.</returns>
        public async Task DeleteNetworkAsync(int id, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/networks/{1}", ApiRoot, id);
            _ = await DeleteAsync<HuduNetwork>(path, ct: cancellationToken);
        }
    }
}
