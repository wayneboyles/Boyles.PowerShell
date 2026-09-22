using Boyles.PowerShell.Hudu.Models;

using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.Hudu.Builders
{
    internal static class HuduRequestBuilder
    {
        public static JObject BuildAssetLayoutJson(object body, HuduAssetLayoutField[]? fields = null)
        {
            JObject bodyObject = body.ConvertToJObject();

            bodyObject["fields"] = JArray.FromObject(fields ?? Array.Empty<HuduAssetLayoutField>());

            var wrapper = new JObject
            {
                ["asset_layout"] = bodyObject
            };

            return wrapper;
        }

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
