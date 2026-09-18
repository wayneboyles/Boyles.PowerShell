using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Partial class containing Hudu article-related API operations.
    /// </summary>
    public partial class HuduClient
    {
        /// <summary>
        /// Retrieves all articles matching the given filters synchronously, automatically
        /// paging through the full result set.
        /// </summary>
        /// <param name="query">Optional filter parameters (name, company_id, draft, enable_sharing, slug, search).</param>
        /// <returns>A list of matching <see cref="HuduArticle"/> records.</returns>
        public List<HuduArticle> GetArticles(Dictionary<string, string>? query = null) => Sync(GetArticlesAsync(query));

        /// <summary>
        /// Retrieves all articles matching the given filters asynchronously, automatically
        /// paging through the full result set. Pagination is driven by page/page_size query
        /// parameters via GetAllPagesAsync.
        /// </summary>
        /// <param name="query">Optional filter parameters (name, company_id, draft, enable_sharing, slug, search).</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to a list of matching <see cref="HuduArticle"/> records.</returns>
        public async Task<List<HuduArticle>> GetArticlesAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/articles", ApiRoot);
            return await GetAllPagesAsync<HuduArticle>(path, query, itemsProperty: "articles", offsetParam: "page", limitParam: "page_size", ct: cancellationToken);
        }

        /// <summary>
        /// Retrieves a single specific page of articles synchronously, without paging further.
        /// </summary>
        /// <param name="query">Optional filter parameters merged into the request alongside page and page_size.</param>
        /// <param name="page">The 1-based page number to retrieve.</param>
        /// <param name="pageSize">The number of items requested per page.</param>
        /// <returns>The single page of matching <see cref="HuduArticle"/> records, as returned by the API.</returns>
        public List<HuduArticle> GetArticlesPage(Dictionary<string, string>? query, int page, int pageSize) => Sync(GetArticlesPageAsync(query, page, pageSize));

        /// <summary>
        /// Retrieves a single specific page of articles asynchronously, without paging further.
        /// Use this instead of <see cref="GetArticlesAsync"/> when the caller has explicitly
        /// requested a page and page size rather than the full result set.
        /// </summary>
        /// <param name="query">Optional filter parameters merged into the request alongside page and page_size.</param>
        /// <param name="page">The 1-based page number to retrieve.</param>
        /// <param name="pageSize">The number of items requested per page.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the single page of matching <see cref="HuduArticle"/> records, as returned by the API.</returns>
        public async Task<List<HuduArticle>> GetArticlesPageAsync(Dictionary<string, string>? query, int page, int pageSize, CancellationToken cancellationToken = default)
        {
            var q = new Dictionary<string, string>(query ?? new Dictionary<string, string>(), StringComparer.Ordinal)
            {
                ["page"] = page.ToString(CultureInfo.InvariantCulture),
                ["page_size"] = pageSize.ToString(CultureInfo.InvariantCulture)
            };

            string path = string.Format(CultureInfo.InvariantCulture, "{0}/articles", ApiRoot);
            return await GetAsync<List<HuduArticle>>(path, q, itemsProperty: "articles", ct: cancellationToken);
        }

        /// <summary>
        /// Retrieves a single article by its ID synchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu article ID.</param>
        /// <returns>The matching <see cref="HuduArticle"/>.</returns>
        public HuduArticle GetArticle(int id) => Sync(GetArticleAsync(id));

        /// <summary>
        /// Retrieves a single article by its ID asynchronously.
        /// </summary>
        /// <param name="id">The numeric Hudu article ID.</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the matching <see cref="HuduArticle"/>.</returns>
        public async Task<HuduArticle> GetArticleAsync(int id, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/articles/{1}", ApiRoot, id);
            return await GetAsync<HuduArticle>(path, itemsProperty: "article", ct: cancellationToken);
        }

        /// <summary>
        /// Creates a new article record in Hudu synchronously.
        /// </summary>
        /// <param name="body">
        /// The request body representing the article to create. Wrapped in an "article"
        /// envelope property before being sent, per the Hudu API's expected request shape.
        /// </param>
        /// <returns>The newly created <see cref="HuduArticle"/>.</returns>
        public HuduArticle NewArticle(object body) => Sync(NewArticleAsync(body));

        /// <summary>
        /// Asynchronously creates a new article record in Hudu.
        /// </summary>
        /// <param name="body">
        /// The request body representing the article to create. Converted to a JObject and
        /// wrapped in an "article" envelope property before being sent, per the Hudu API's
        /// expected request shape.
        /// </param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>A task that resolves to the newly created <see cref="HuduArticle"/>.</returns>
        public async Task<HuduArticle> NewArticleAsync(object body, CancellationToken cancellationToken = default)
        {
            JObject bodyObject = body.ConvertToJObject();

            var wrapper = new JObject
            {
                ["article"] = bodyObject
            };

            string path = string.Format(CultureInfo.InvariantCulture, "{0}/articles", ApiRoot);

            return await PostAsync<HuduArticle>(path, wrapper, ct: cancellationToken);
        }

        /// <summary>
        /// Synchronously updates an article.
        /// </summary>
        /// <param name="id">The unique identifier of the article to update.</param>
        /// <param name="body">The request body containing the updated article data.</param>
        /// <returns>The updated <see cref="HuduArticle"/>.</returns>
        public HuduArticle UpdateArticle(int id, object body) => Sync(UpdateArticleAsync(id, body));

        /// <summary>
        /// Asynchronously updates an article.
        /// </summary>
        /// <param name="id">The unique identifier of the article to update.</param>
        /// <param name="body">The request body containing the updated article data.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>
        /// A task that represents the asynchronous operation.
        /// The task result contains the updated <see cref="HuduArticle"/>.
        /// </returns>
        public async Task<HuduArticle> UpdateArticleAsync(int id, object body, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/articles/{1}", ApiRoot, id);
            return await PutAsync<HuduArticle>(path, body, null, cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Synchronously deletes an article.
        /// </summary>
        /// <param name="id">The unique identifier of the article to delete.</param>
        public void DeleteArticle(int id) => Sync(DeleteArticleAsync(id));

        /// <summary>
        /// Asynchronously deletes an article.
        /// </summary>
        /// <param name="id">The unique identifier of the article to delete.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>A task that represents the asynchronous delete operation.</returns>
        public async Task DeleteArticleAsync(int id, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/articles/{1}", ApiRoot, id);
            await DeleteAsync<HuduArticle>(path, ct: cancellationToken);
        }

        /// <summary>
        /// Archives an article record in Hudu, marking it as inactive.
        /// </summary>
        /// <param name="id">The unique identifier of the article to archive.</param>
        /// <returns>The updated <see cref="HuduArticle"/> reflecting the archived state.</returns>
        public HuduArticle ArchiveArticle(int id) => Sync(ArchiveArticleAsync(id));

        /// <summary>
        /// Asynchronously archives an article record in Hudu, marking it as inactive.
        /// </summary>
        /// <param name="id">The unique identifier of the article to archive.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>
        /// A task that resolves to the updated <see cref="HuduArticle"/> reflecting the archived state.
        /// </returns>
        public async Task<HuduArticle> ArchiveArticleAsync(int id, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/articles/{1}/archive", ApiRoot, id);
            return await PutAsync<HuduArticle>(path, null, "article", cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Synchronously unarchives an article.
        /// </summary>
        /// <param name="id">The unique identifier of the article to unarchive.</param>
        /// <returns>The updated <see cref="HuduArticle"/> after unarchiving.</returns>
        public HuduArticle UnarchiveArticle(int id) => Sync(UnarchiveArticleAsync(id));

        /// <summary>
        /// Asynchronously unarchives an article.
        /// </summary>
        /// <param name="id">The unique identifier of the article to unarchive.</param>
        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>
        /// <returns>
        /// A task that represents the asynchronous operation.
        /// The task result contains the updated <see cref="HuduArticle"/> after unarchiving.
        /// </returns>
        public async Task<HuduArticle> UnarchiveArticleAsync(int id, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/articles/{1}/unarchive", ApiRoot, id);
            return await PutAsync<HuduArticle>(path, null, "article", cancellationToken).ConfigureAwait(false);
        }
    }
}
