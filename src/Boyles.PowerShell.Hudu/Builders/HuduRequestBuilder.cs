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
        /// <summary>
        /// Builds <c>{ "asset_layout": { ...body, "fields": [...] } }</c>.
        /// </summary>
        /// <param name="body">The layout properties, e.g. <c>name</c> and <c>icon</c>; a hashtable, JObject or POCO.</param>
        /// <param name="fields">
        /// The field definitions, or <see langword="null"/> to omit <c>fields</c> entirely. Hudu replaces
        /// a layout's field collection wholesale whenever <c>fields</c> is present, so an update that
        /// only changes layout properties must leave it out rather than send an empty array.
        /// </param>
        /// <returns>The wrapped request body.</returns>
        public static JObject BuildAssetLayoutJson(object body, HuduAssetLayoutField[]? fields = null)
        {
            JObject bodyObject = body.ConvertToJObject();

            if (fields != null)
            {
                bodyObject["fields"] = JArray.FromObject(fields);
            }

            var wrapper = new JObject
            {
                ["asset_layout"] = bodyObject
            };

            return wrapper;
        }

        /// <summary>
        /// Builds <c>{ "asset": { ...body, "custom_fields": [ { "field_key": value }, ... ] } }</c>.
        /// Fields with an empty <see cref="HuduAssetField.WireKey"/> are skipped.
        /// </summary>
        /// <param name="body">The asset properties, e.g. <c>name</c>; a hashtable, JObject or POCO.</param>
        /// <param name="fields">The custom field values; <see langword="null"/> is written as an empty array.</param>
        /// <returns>The wrapped request body.</returns>
        public static JObject BuildAssetJson(object body, HuduAssetField[]? fields = null)
        {
            JObject bodyObject = body.ConvertToJObject();

            // Hudu expects one single-key object per field, keyed by the field's snake cased
            // label - not a serialization of HuduAssetField's own read-shape properties.
            var customFields = new JArray();
            foreach (HuduAssetField field in fields ?? Array.Empty<HuduAssetField>())
            {
                string key = field.WireKey;
                if (key.Length == 0)
                {
                    continue;
                }

                customFields.Add(new JObject
                {
                    [key] = field.Value == null ? JValue.CreateNull() : JToken.FromObject(field.Value)
                });
            }

            bodyObject["custom_fields"] = customFields;

            var wrapper = new JObject
            {
                ["asset"] = bodyObject
            };

            return wrapper;
        }
    }
}
