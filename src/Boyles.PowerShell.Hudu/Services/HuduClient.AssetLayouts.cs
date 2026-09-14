using System.Globalization;

using Boyles.PowerShell.Hudu.Builders;
using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    public partial class HuduClient
    {
        /// <summary>
        /// Retrieves a single asset layout, including its field definitions.
        /// </summary>
        /// <param name="assetLayoutId">
        /// The identifier of the layout.
        /// </param>
        /// <returns>
        /// The layout, or <see langword="null"/> when it does not exist.
        /// </returns>
        public HuduAssetLayout? GetAssetLayout(int assetLayoutId) => Sync(GetAssetLayoutAsync(assetLayoutId));

        /// <summary>
        /// Retrieves a single asset layout, including its field definitions.
        /// </summary>
        /// <param name="assetLayoutId">
        /// The identifier of the layout.
        /// </param>
        /// <param name="cancellationToken">
        /// A token used to cancel the request.
        /// </param>
        /// <returns>
        /// A task producing the layout, or <see langword="null"/> when it does not exist.
        /// </returns>
        public async Task<HuduAssetLayout?> GetAssetLayoutAsync(int assetLayoutId, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_layouts/{1}", ApiRoot, assetLayoutId);
            return await GetAsync<HuduAssetLayout?>(path, null, "asset_layout", cancellationToken);
        }

        /// <summary>
        /// Retrieves every asset layout defined on the instance.
        /// </summary>
        /// <returns>
        /// The layouts across all pages.
        /// </returns>
        public List<HuduAssetLayout> GetAssetLayouts(Dictionary<string, string>? query = null) => Sync(GetAssetLayoutsAsync(query));

        /// <summary>
        /// Retrieves every asset layout defined on the instance.
        /// </summary>
        /// <param name="cancellationToken">
        /// A token used to cancel the request.
        /// </param>
        /// <returns>
        /// A task producing the layouts across all pages.
        /// </returns>
        public async Task<List<HuduAssetLayout>> GetAssetLayoutsAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_layouts", ApiRoot);
            List<HuduAssetLayout> layouts = await GetAllPagesAsync<HuduAssetLayout>(path, query, limitParam: "page_size", offsetParam: "page", itemsProperty: "asset_layouts", ct: cancellationToken).ConfigureAwait(false);
            return layouts;
        }

        /// <summary>
        /// Creates an asset layout from a set of field definitions.
        /// </summary>
        /// <param name="name">
        /// The display name of the layout.
        /// </param>
        /// <param name="fields">
        /// The field definitions, ordinarily produced by <see cref="HuduLayoutFieldSet.Build"/>.
        /// </param>
        /// <param name="icon">
        /// The optional icon name shown alongside assets of this layout.
        /// </param>
        /// <returns>
        /// The created layout as returned by Hudu.
        /// </returns>
        public HuduAssetLayout? NewAssetLayout(object body, HuduAssetLayoutField[] fields)
        {
            return Sync(NewAssetLayoutAsync(body, fields));
        }

        /// <summary>
        /// Creates an asset layout from a set of field definitions.
        /// </summary>
        /// <param name="body">
        /// The layout properties (e.g. <c>name</c>, <c>icon</c>) to submit alongside the fields.
        /// </param>
        /// <param name="fields">
        /// The field definitions, ordinarily produced by <see cref="HuduLayoutFieldSet.Build"/>.
        /// </param>
        /// <param name="cancellationToken">
        /// A token used to cancel the request.
        /// </param>
        /// <returns>
        /// A task producing the created layout as returned by Hudu.
        /// </returns>
        public async Task<HuduAssetLayout?> NewAssetLayoutAsync(object body, HuduAssetLayoutField[] fields, CancellationToken cancellationToken = default)
        {
            var wrapper = HuduRequestBuilder.BuildAssetLayoutJson(body, fields);

            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_layouts", ApiRoot);

            return await PostAsync<HuduAssetLayout?>(path, wrapper, "asset_layout", cancellationToken);
        }

        public HuduAssetLayout? UpdateAssetLayout(int id, object body, HuduAssetLayoutField[]? fields) =>
            Sync(UpdateAssetLayoutAsync(id, body, fields));

        public async Task<HuduAssetLayout?> UpdateAssetLayoutAsync(int id, object body, HuduAssetLayoutField[]? fields = null, CancellationToken ct = default)
        {
            //var combinedFields = await AddAssetLayoutFieldsAsync(id, fields, ct);

            var wrapper = HuduRequestBuilder.BuildAssetLayoutJson(body, fields);

            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_layouts/{1}", ApiRoot, id);

            return await PutAsync<HuduAssetLayout?>(path, wrapper, "asset_layout", ct);
        }

        /// <summary>
        /// Appends field definitions to an existing layout, leaving current fields and their data intact.
        /// </summary>
        /// <param name="assetLayoutId">
        /// The identifier of the layout to amend.
        /// </param>
        /// <param name="fields">
        /// The field definitions to append.
        /// </param>
        /// <param name="cancellationToken">
        /// A token used to cancel the request.
        /// </param>
        /// <returns>
        /// A task producing the amended layout as returned by Hudu.
        /// </returns>
        /// <remarks>
        /// A layout update replaces the field collection wholesale, so the existing definitions are read
        /// and resubmitted alongside the additions. Their identifiers are preserved, which is what keeps
        /// data already stored against those fields attached.
        /// </remarks>
        public async Task<HuduAssetLayout?> AddAssetLayoutFieldsAsync(int assetLayoutId, HuduAssetLayoutField[] fields, CancellationToken cancellationToken)
        {
            HuduAssetLayout? existing = await GetAssetLayoutAsync(assetLayoutId, cancellationToken).ConfigureAwait(false);
            if (existing == null)
            {
                throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture, "Asset layout {0} was not found.", assetLayoutId));
            }

            List<HuduAssetLayoutField> combined = new List<HuduAssetLayoutField>(existing.Fields);
            int position = combined.Count;
            foreach (HuduAssetLayoutField field in fields ?? Array.Empty<HuduAssetLayoutField>())
            {
                if (existing.GetField(field.Label ?? string.Empty) != null)
                {
                    continue;
                }

                position++;
                field.Position = position;
                combined.Add(field);
            }

            Dictionary<string, object?> body = new Dictionary<string, object?>(StringComparer.Ordinal)
            {
                ["asset_layout"] = new Dictionary<string, object?>(StringComparer.Ordinal)
                {
                    ["fields"] = combined.ToArray()
                }
            };

            string path = string.Format(CultureInfo.InvariantCulture, "{0}/asset_layouts/{1}", ApiRoot, assetLayoutId);
            return await PutAsync<HuduAssetLayout>(path, body, "asset_layout", cancellationToken).ConfigureAwait(false);
        }

        /// <summary>
        /// Reports which labels in a field set have no corresponding field on the supplied layout.
        /// </summary>
        /// <param name="layout">
        /// The layout to validate against.
        /// </param>
        /// <param name="fields">
        /// The field set to inspect.
        /// </param>
        /// <returns>
        /// The wire keys present in the set but absent from the layout.
        /// </returns>
        /// <remarks>
        /// Hudu silently discards unrecognised custom field keys rather than returning an error, which
        /// makes a typo in a label very difficult to notice. Calling this before a write turns that
        /// silent loss into a visible one.
        /// </remarks>
        public static string[] FindUnknownFields(HuduAssetLayout layout, HuduFieldSet fields)
        {
            if (layout == null)
            {
                throw new ArgumentNullException(nameof(layout));
            }

            if (fields == null)
            {
                throw new ArgumentNullException(nameof(fields));
            }

            List<string> unknown = new List<string>();
            foreach (string key in fields.Keys)
            {
                if (layout.GetField(key) == null)
                {
                    unknown.Add(key);
                }
            }

            return unknown.ToArray();
        }
    }
}
