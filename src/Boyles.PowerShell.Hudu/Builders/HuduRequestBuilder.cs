using Boyles.PowerShell.Hudu.Models;

using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.Hudu.Builders
{
    /// <summary>
    /// Assembles the nested request JSON Hudu expects for the Assets and AssetLayouts endpoints,
    /// keeping envelope-shaping logic out of the client methods and cmdlets. Newer resources build
    /// their bodies with ConvertTo-RequestBody instead.
    /// </summary>
    internal static class HuduRequestBuilder
    {
        public static JObject BuildAssetLayoutJson(object body, HuduAssetLayoutField[]? fields = null) =>
            BuildEnvelope("asset_layout", body, "fields", fields, JToken.FromObject, omitWhenNull: true);

        public static JObject BuildAssetJson(object body, HuduAssetField[]? fields = null) =>
            BuildEnvelope("asset", body, "custom_fields", fields, ToCustomField);

        public static JObject BuildListJson(object body, HuduListItem[]? items = null) =>
            BuildEnvelope("list", body, "list_items_attributes", items, ToListItem);

        /// <summary>
        /// Builds <c>{ "rootKey": { ...body, "collectionKey": [ ... ] } }</c>.
        /// </summary>
        /// <typeparam name="T">The element type of the child collection.</typeparam>
        /// <param name="rootKey">The envelope key Hudu expects, e.g. <c>asset</c>.</param>
        /// <param name="body">The parent properties; a hashtable, JObject or POCO.</param>
        /// <param name="collectionKey">The property that receives the child array.</param>
        /// <param name="items">The child items, or <see langword="null"/> for none.</param>
        /// <param name="project">Maps an item to its wire form; return <see langword="null"/> to skip it.</param>
        /// <param name="omitWhenNull">
        /// When <see langword="true"/> and <paramref name="items"/> is null, the collection key is left out
        /// instead of written as an empty array. Needed where Hudu replaces the collection wholesale.
        /// </param>
        /// <returns>The wrapped request body.</returns>
        private static JObject BuildEnvelope<T>(string rootKey, object body, string collectionKey, IEnumerable<T>? items, Func<T, JToken?> project, bool omitWhenNull = false)
        {
            JObject bodyObject = body.ConvertToJObject();

            if (items != null || !omitWhenNull)
            {
                var array = new JArray();
                foreach (T item in items ?? Enumerable.Empty<T>())
                {
                    JToken? token = project(item);
                    if (token != null)
                    {
                        array.Add(token);
                    }
                }

                bodyObject[collectionKey] = array;
            }

            return new JObject { [rootKey] = bodyObject };
        }

        /// <summary>
        /// Projects an asset field to <c>{ "field_key": value }</c>, or null when it has no wire key.
        /// </summary>
        /// <param name="field">The field to project.</param>
        /// <returns>The single-key object, or <see langword="null"/> to skip the field.</returns>
        private static JToken? ToCustomField(HuduAssetField field)
        {
            var key = field.WireKey;
            if (key.Length == 0)
            {
                return null;
            }

            return new JObject
            {
                [key] = field.Value == null ? JValue.CreateNull() : JToken.FromObject(field.Value)
            };
        }

        /// <summary>
        /// Projects a list item to <c>{ "id": 1, "name": "..." }</c>, or null when it has no name.
        /// </summary>
        /// <param name="item">The list item to project.</param>
        /// <returns>The item object, or <see langword="null"/> to skip the item.</returns>
        private static JToken? ToListItem(HuduListItem item)
        {
            if (string.IsNullOrWhiteSpace(item.Name))
            {
                return null;
            }

            var json = new JObject
            {
                ["name"] = item.Name
            };

            if (item.Id != null)
            {
                json["id"] = item.Id;
            }

            return json;
        }
    }
}
