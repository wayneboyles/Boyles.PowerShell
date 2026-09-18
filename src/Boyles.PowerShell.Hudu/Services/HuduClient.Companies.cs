using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Partial class containing Hudu company-related API operations.
    /// </summary>
    public partial class HuduClient
    {
        /// <summary>
        /// Retrieves all companies from the Hudu API synchronously.
        /// </summary>
        /// <returns>A list of all <see cref="HuduCompany"/> records.</returns>
        public List<HuduCompany> GetCompanies(Dictionary<string, string>? query = null) => Sync(GetCompaniesAsync(query));

        /// <summary>
        /// Retrieves all companies from the Hudu API asynchronously.
        /// </summary>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to a list of all <see cref="HuduCompany"/> records.</returns>
        public async Task<List<HuduCompany>> GetCompaniesAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies", ApiRoot);
            return await GetAllPagesAsync<HuduCompany>(path, query, offsetParam: "page", limitParam: "page_size", itemsProperty: "companies", ct: cancellationToken).ConfigureAwait(false);
        }

        public List<HuduCompany> GetCompaniesPage(Dictionary<string, string>? query, int page, int pageSize) => Sync(GetCompaniesPageAsync(query, page, pageSize));

        public async Task<List<HuduCompany>> GetCompaniesPageAsync(Dictionary<string, string>? query, int page, int pageSize, CancellationToken cancellationToken = default)
        {
            var q = new Dictionary<string, string>(query ?? new Dictionary<string, string>(), StringComparer.Ordinal)
            {
                ["page"] = page.ToString(CultureInfo.InvariantCulture),
                ["page_size"] = pageSize.ToString(CultureInfo.InvariantCulture)
            };

            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies", ApiRoot);
            return await GetAsync<List<HuduCompany>>(path, q, itemsProperty: "companies", ct: cancellationToken);
        }

        /// <summary>
        /// Retrieves a single company by its ID synchronously.
        /// </summary>
        /// <param name="companyId">The numeric Hudu company ID.</param>
        /// <returns>The matching <see cref="HuduCompany"/>, or <c>null</c> if not found.</returns>
        public HuduCompany? GetCompany(int companyId) => Sync(GetCompanyAsync(companyId, cancellationToken: CancellationToken.None));

        /// <summary>
        /// Retrieves a single company by its ID asynchronously.
        /// </summary>
        /// <param name="companyId">The numeric Hudu company ID.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the matching <see cref="HuduCompany"/>, or <c>null</c> if not found.</returns>
        public async Task<HuduCompany?> GetCompanyAsync(int companyId, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}", ApiRoot, companyId);
            return await GetAsync<HuduCompany>(path, null, "company", cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Creates a new company record in Hudu.
        /// </summary>
        /// <param name="body">
        /// The request body representing the company to create.
        /// </param>
        /// <returns>
        /// The newly created <see cref="HuduCompany"/>, or <see langword="null"/> if the API returned no content.
        /// </returns>
        public HuduCompany? NewCompany(object body) => Sync(NewCompanyAsync(body));

        /// <summary>
        /// Asynchronously creates a new company record in Hudu.
        /// </summary>
        /// <param name="body">
        /// The request body representing the company to create.
        /// </param>
        /// <param name="cancellationToken">
        /// A token to monitor for cancellation requests.
        /// </param>
        /// <returns>
        /// A task that resolves to the newly created <see cref="HuduCompany"/>,
        /// or <see langword="null"/> if the API returned no content.
        /// </returns>
        public async Task<HuduCompany?> NewCompanyAsync(object body, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies", ApiRoot);
            return await PostAsync<HuduCompany?>(path, body, "company", cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Archives a company record in Hudu, marking it as inactive.
        /// </summary>
        /// <param name="companyId">
        /// The unique identifier of the company to archive.
        /// </param>
        /// <returns>
        /// The updated <see cref="HuduCompany"/> reflecting the archived state.
        /// </returns>
        public HuduCompany ArchiveCompany(int companyId) => Sync(ArchiveCompanyAsync(companyId));

        /// <summary>
        /// Asynchronously archives a company record in Hudu, marking it as inactive.
        /// </summary>
        /// <param name="companyId">
        /// The unique identifier of the company to archive.
        /// </param>
        /// <param name="cancellationToken">
        /// A token to monitor for cancellation requests.
        /// </param>
        /// <returns>
        /// A task that resolves to the updated <see cref="HuduCompany"/> reflecting the archived state.
        /// </returns>
        public async Task<HuduCompany> ArchiveCompanyAsync(int companyId, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/archive", ApiRoot, companyId);
            return await PutAsync<HuduCompany>(path, null, "company", cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Synchronously unarchives a company.
        /// </summary>
        /// <param name="companyId">The unique identifier of the company to unarchive.</param>
        /// <returns>The updated <see cref="HuduCompany"/> after unarchiving.</returns>
        public HuduCompany UnarchiveCompany(int companyId) => Sync(UnarchiveCompanyAsync(companyId));

        /// <summary>
        /// Asynchronously unarchives a company.
        /// </summary>
        /// <param name="companyId">The unique identifier of the company to unarchive.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>
        /// A task that represents the asynchronous operation.
        /// The task result contains the updated <see cref="HuduCompany"/> after unarchiving.
        /// </returns>
        public async Task<HuduCompany> UnarchiveCompanyAsync(int companyId, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/unarchive", ApiRoot, companyId);
            return await PutAsync<HuduCompany>(path, null, "company", cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Synchronously updates a company.
        /// </summary>
        /// <param name="companyId">The unique identifier of the company to update.</param>
        /// <param name="body">The request body containing the updated company data.</param>
        /// <returns>The updated <see cref="HuduCompany"/>.</returns>
        public HuduCompany UpdateCompany(int companyId, object body) => Sync(UpdateCompanyAsync(companyId, body));

        /// <summary>
        /// Asynchronously updates a company.
        /// </summary>
        /// <param name="companyId">The unique identifier of the company to update.</param>
        /// <param name="body">The request body containing the updated company data.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>
        /// A task that represents the asynchronous operation.
        /// The task result contains the updated <see cref="HuduCompany"/>.
        /// </returns>
        public async Task<HuduCompany> UpdateCompanyAsync(int companyId, object body, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}", ApiRoot, companyId);
            return await PutAsync<HuduCompany>(path, body, "company", cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Synchronously deletes a company.
        /// </summary>
        /// <param name="companyId">The unique identifier of the company to delete.</param>
        public void DeleteCompany(int companyId) => Sync(DeleteCompanyAsync(companyId));

        /// <summary>
        /// Asynchronously deletes a company.
        /// </summary>
        /// <param name="companyId">The unique identifier of the company to delete.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>A task that represents the asynchronous delete operation.</returns>
        public async Task DeleteCompanyAsync(int companyId, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}", ApiRoot, companyId);
            await DeleteAsync<HuduCompany>(path, null, cancellationToken).ConfigureAwait(false);
        }
    }
}
