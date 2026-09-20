using System.ComponentModel.Design;
using System.Globalization;

using Boyles.PowerShell.Hudu.Builders;
using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    public partial class HuduClient
    {
        public HuduAsset GetAssetsForCompany(int companyId, Dictionary<string, string>? query = null) => Sync(GetAssetsForCompanyAsync(companyId, query));

        public async Task<HuduAsset> GetAssetsForCompanyAsync(int companyId, Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            return new HuduAsset();
        }

        public List<HuduAsset> GetAssets(Dictionary<string, string>? query = null) => Sync(GetAssetsAsync(query));

        public async Task<List<HuduAsset>> GetAssetsAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/assets", ApiRoot);
            return await GetAllPagesAsync<HuduAsset>(path, query, itemsProperty: "assets", offsetParam: "page", limitParam: "page_size");
        }

        public HuduArticle ArchiveAsset(int id, int companyId) => Sync(ArchiveAssetAsync(id, companyId));

        public async Task<HuduArticle> ArchiveAssetAsync(int id, int companyId, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/assets/{2}/archive", ApiRoot, companyId, id);
            return await PutAsync<HuduArticle>(path, null, "article", cancellationToken).ConfigureAwait(false);
        }

        public HuduArticle UnarchiveAsset(int id, int companyId) => Sync(UnarchiveAssetAsync(id, companyId));

        public async Task<HuduArticle> UnarchiveAssetAsync(int id, int companyId, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/articles/{1}/unarchive", ApiRoot, id);
            return await PutAsync<HuduArticle>(path, null, "article", cancellationToken).ConfigureAwait(false);
        }

        ///// <summary>
        ///// Retrieves a single asset, including its populated custom fields.
        ///// </summary>
        ///// <param name="companyId">
        ///// The identifier of the owning company.
        ///// </param>
        ///// <param name="assetId">
        ///// The identifier of the asset.
        ///// </param>
        ///// <param name="cancellationToken">
        ///// A token used to cancel the request.
        ///// </param>
        ///// <returns>
        ///// A task producing the asset, or <see langword="null"/> when it does not exist.
        ///// </returns>
        //public async Task<HuduAsset> GetAssetAsync(int assetId, CancellationToken cancellationToken = default)
        //{
        //    string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/assets/{2}", ApiRoot, companyId, assetId);
        //    return await GetAsync<HuduAsset>(path, null, "asset", cancellationToken);
        //}

        ///// <summary>
        ///// Retrieves every asset belonging to a company, optionally restricted to a single layout.
        ///// </summary>
        ///// <param name="companyId">
        ///// The identifier of the owning company.
        ///// </param>
        ///// <param name="assetLayoutId">
        ///// An optional layout identifier used to filter the result.
        ///// </param>
        ///// <returns>
        ///// The matching assets across all pages.
        ///// </returns>
        //public List<HuduAsset> GetAssets(Dictionary<string, string>? query) => Sync(GetAssetsAsync(query));

        ///// <summary>
        ///// Retrieves every asset belonging to a company, optionally restricted to a single layout.
        ///// </summary>
        ///// <param name="companyId">
        ///// The identifier of the owning company.
        ///// </param>
        ///// <param name="assetLayoutId">
        ///// An optional layout identifier used to filter the result.
        ///// </param>
        ///// <param name="cancellationToken">
        ///// A token used to cancel the request.
        ///// </param>
        ///// <returns>
        ///// A task producing the matching assets across all pages.
        ///// </returns>
        //public async Task<List<HuduAsset>> GetAssetsAsync(Dictionary<string, string>? query, CancellationToken cancellationToken = default)
        //{
        //    string path = string.Format(CultureInfo.InvariantCulture, "{0}/assets", ApiRoot);

        //    List<HuduAsset> assets = await GetAsync<List<HuduAsset>>(path, query, itemsProperty: "assets", ct: cancellationToken).ConfigureAwait(false);

        //    return assets;
        //}

        ///// <summary>
        ///// Creates an asset with the supplied custom field values.
        ///// </summary>
        ///// <param name="companyId">
        ///// The identifier of the owning company.
        ///// </param>
        ///// <param name="name">
        ///// The display name of the new asset.
        ///// </param>
        ///// <param name="assetLayoutId">
        ///// The identifier of the layout defining the asset's fields.
        ///// </param>
        ///// <param name="fields">
        ///// The custom field values to populate. May be <see langword="null"/> for an empty custom card.
        ///// </param>
        ///// <returns>
        ///// The created asset as returned by Hudu.
        ///// </returns>
        //public HuduAsset? NewAsset(int companyId, object body, HuduAssetField[]? fields) =>
        //    Sync(NewAssetAsync(companyId, body, fields));

        ///// <summary>
        ///// Creates an asset with the supplied custom field values.
        ///// </summary>
        ///// <param name="companyId">
        ///// The identifier of the owning company.
        ///// </param>
        ///// <param name="name">
        ///// The display name of the new asset.
        ///// </param>
        ///// <param name="assetLayoutId">
        ///// The identifier of the layout defining the asset's fields.
        ///// </param>
        ///// <param name="fields">
        ///// The custom field values to populate. May be <see langword="null"/> for an empty custom card.
        ///// </param>
        ///// <param name="cancellationToken">
        ///// A token used to cancel the request.
        ///// </param>
        ///// <returns>
        ///// A task producing the created asset as returned by Hudu.
        ///// </returns>
        //public async Task<HuduAsset?> NewAssetAsync(int companyId, object body, HuduAssetField[]? fields, CancellationToken cancellationToken = default)
        //{
        //    string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/assets", ApiRoot, companyId);

        //    var wrapper = HuduRequestBuilder.BuildAssetJson(body, fields);

        //    return await PostAsync<HuduAsset?>(path, wrapper, "asset", cancellationToken);
        //}

        ///// <summary>
        ///// Populates custom fields on an existing asset.
        ///// </summary>
        ///// <param name="companyId">
        ///// The identifier of the owning company.
        ///// </param>
        ///// <param name="assetId">
        ///// The identifier of the asset to update.
        ///// </param>
        ///// <param name="fields">
        ///// The field values to apply.
        ///// </param>
        ///// <param name="replace">
        ///// When <see langword="false"/>, the asset's current field values are read first and the supplied
        ///// values are layered on top, so untouched fields are preserved. When <see langword="true"/>, the
        ///// supplied set is written as-is and any field it omits is cleared.
        ///// </param>
        ///// <returns>
        ///// The updated asset as returned by Hudu.
        ///// </returns>
        //public HuduAsset? SetAssetFields(int companyId, int assetId, HuduFieldSet fields, bool replace = false) =>
        //    Sync(SetAssetFieldsAsync(companyId, assetId, fields, replace));

        ///// <summary>
        ///// Populates custom fields on an existing asset.
        ///// </summary>
        ///// <param name="companyId">
        ///// The identifier of the owning company.
        ///// </param>
        ///// <param name="assetId">
        ///// The identifier of the asset to update.
        ///// </param>
        ///// <param name="fields">
        ///// The field values to apply.
        ///// </param>
        ///// <param name="replace">
        ///// When <see langword="false"/>, the asset's current field values are read first and the supplied
        ///// values are layered on top. When <see langword="true"/>, omitted fields are cleared.
        ///// </param>
        ///// <param name="cancellationToken">
        ///// A token used to cancel the request.
        ///// </param>
        ///// <returns>
        ///// A task producing the updated asset as returned by Hudu.
        ///// </returns>
        //public async Task<HuduAsset?> SetAssetFieldsAsync(int companyId, int assetId, HuduFieldSet fields, bool replace, CancellationToken cancellationToken = default)
        //{
        //    if (fields == null)
        //    {
        //        throw new ArgumentNullException(nameof(fields));
        //    }

        //    HuduAsset? current = await GetAssetAsync(companyId, assetId, cancellationToken).ConfigureAwait(false);
        //    if (current == null)
        //    {
        //        throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture, "Asset {0} was not found in company {1}.", assetId, companyId));
        //    }

        //    HuduFieldSet effective = replace ? fields.Clone() : HuduFieldSet.FromAsset(current).Merge(fields);

        //    string path = string.Format(CultureInfo.InvariantCulture, "{0}/companies/{1}/assets/{2}", ApiRoot, companyId, assetId);
        //    object body = BuildAssetPayload(current.Name, current.AssetLayoutId, effective);

        //    return await PutAsync<HuduAsset?>(path, body, "asset", cancellationToken).ConfigureAwait(false);
        //}

        ///// <summary>
        ///// Populates a single custom field on an existing asset, preserving all other values.
        ///// </summary>
        ///// <param name="companyId">
        ///// The identifier of the owning company.
        ///// </param>
        ///// <param name="assetId">
        ///// The identifier of the asset to update.
        ///// </param>
        ///// <param name="label">
        ///// The field label, in either human readable or snake cased form.
        ///// </param>
        ///// <param name="value">
        ///// The value to store.
        ///// </param>
        ///// <returns>
        ///// The updated asset as returned by Hudu.
        ///// </returns>
        //public HuduAsset? SetAssetField(int companyId, int assetId, string label, object? value)
        //{
        //    HuduFieldSet set = HuduFieldSet
        //        .Create()
        //        .Set(label, value);

        //    return SetAssetFields(companyId, assetId, set, false);
        //}

        ///// <summary>
        ///// Builds the request body Hudu expects when creating or updating an asset.
        ///// </summary>
        ///// <param name="name">
        ///// The asset display name.
        ///// </param>
        ///// <param name="assetLayoutId">
        ///// The identifier of the asset layout.
        ///// </param>
        ///// <param name="fields">
        ///// The custom field values, or <see langword="null"/> to omit the custom card entirely.
        ///// </param>
        ///// <returns>
        ///// The serialisable request body.
        ///// </returns>
        ///// <remarks>
        ///// The <c>custom_fields</c> property is an array containing exactly one object, keyed by snake
        ///// cased field label. The single element wrapper is a quirk of the Hudu schema rather than a
        ///// meaningful collection.
        ///// </remarks>
        //private static object BuildAssetPayload(string? name, int? assetLayoutId, HuduFieldSet? fields)
        //{
        //    Dictionary<string, object?> asset = new Dictionary<string, object?>(StringComparer.Ordinal);
        //    if (!string.IsNullOrWhiteSpace(name))
        //    {
        //        asset["name"] = name;
        //    }

        //    if (assetLayoutId.HasValue)
        //    {
        //        asset["asset_layout_id"] = assetLayoutId.Value;
        //    }

        //    if (fields != null && fields.Count > 0)
        //    {
        //        asset["custom_fields"] = new object[] { fields.ToPayload() };
        //    }

        //    return new Dictionary<string, object?>(StringComparer.Ordinal)
        //    {
        //        ["asset"] = asset
        //    };
        //}
    }
}
