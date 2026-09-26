using System.Globalization;

using Boyles.PowerShell.Exceptions;
using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Partial class containing Hudu card-related API operations.
    /// </summary>
    public partial class HuduClient
    {
        /// <summary>
        /// Looks up an integrator card by the entity's details in an external integration.
        /// </summary>
        /// <remarks>
        /// Supply either <paramref name="integrationId"/> or <paramref name="integrationIdentifier"/>.
        /// When both are supplied, <paramref name="integrationId"/> takes precedence.
        /// This is a synchronous wrapper over <see cref="GetCardLookupAsync"/> for use from PowerShell.
        /// </remarks>
        /// <param name="integrationSlug">
        /// The slug of the external integration (e.g. "cw_manage", "autotask", "halo").
        /// </param>
        /// <param name="integrationId">
        /// The numeric ID of the entity in the external integration. Required unless
        /// <paramref name="integrationIdentifier"/> is supplied.
        /// </param>
        /// <param name="integrationIdentifier">
        /// The string identifier of the entity in the external integration. Used only when
        /// <paramref name="integrationId"/> is <see langword="null"/>.
        /// </param>
        /// <returns>
        /// The <see cref="HuduCard"/> matching the supplied integration details.
        /// </returns>
        /// <exception cref="ApiException">
        /// Thrown when Hudu returns a non-success status code, such as 401 Unauthorized or 404 Not Found.
        /// </exception>
        public HuduCard GetCardLookup(string integrationSlug, int? integrationId = null, string? integrationIdentifier = null) => Sync(GetCardLookupAsync(integrationSlug, integrationId, integrationIdentifier));

        /// <summary>
        /// Asynchronously looks up an integrator card by the entity's details in an external integration.
        /// </summary>
        /// <remarks>
        /// Supply either <paramref name="integrationId"/> or <paramref name="integrationIdentifier"/>.
        /// When both are supplied, <paramref name="integrationId"/> takes precedence.
        /// Calls <c>GET /cards/lookup</c>.
        /// </remarks>
        /// <param name="integrationSlug">
        /// The slug of the external integration (e.g. "cw_manage", "autotask", "halo").
        /// </param>
        /// <param name="integrationId">
        /// The numeric ID of the entity in the external integration. Required unless
        /// <paramref name="integrationIdentifier"/> is supplied.
        /// </param>
        /// <param name="integrationIdentifier">
        /// The string identifier of the entity in the external integration. Used only when
        /// <paramref name="integrationId"/> is <see langword="null"/>.
        /// </param>
        /// <param name="cancellationToken">
        /// A token used to cancel the request.
        /// </param>
        /// <returns>
        /// A task that resolves to the <see cref="HuduCard"/> matching the supplied integration details.
        /// </returns>
        /// <exception cref="ApiException">
        /// Thrown when Hudu returns a non-success status code, such as 401 Unauthorized or 404 Not Found.
        /// </exception>
        /// <exception cref="OperationCanceledException">
        /// Thrown when <paramref name="cancellationToken"/> is cancelled.
        /// </exception>
        public async Task<HuduCard> GetCardLookupAsync(string integrationSlug, int? integrationId = null, string? integrationIdentifier = null, CancellationToken cancellationToken = default)
        {
            string pathFormat = "{0}/cards/lookup?integration_slug={1}&{2}={3}";

            string path = integrationId != null ? 
                string.Format(CultureInfo.InvariantCulture, pathFormat, ApiRoot, integrationSlug, "integration_id", integrationId) : 
                string.Format(CultureInfo.InvariantCulture, pathFormat, ApiRoot, integrationSlug, "integration_identifier", integrationIdentifier);
            
            return await GetAsync<HuduCard>(path, ct: cancellationToken);
        }
    }
}
