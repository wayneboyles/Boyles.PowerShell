using Boyles.PowerShell.Hudu.Models;

using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.Hudu.Builders
{
    internal static class HuduRequestBuilder
    {
        public static JObject BuildAssetLayoutJson(object body, HuduAssetLayoutField[]? fields = null)
        {
            JObject bodyObject = body.ConvertToJObject();

            // Always attach a "fields" array - empty if none were supplied
            bodyObject["fields"] = JArray.FromObject(fields ?? Array.Empty<HuduAssetLayoutField>());

            // Wrap the whole thing in "asset_layout"
            var wrapper = new JObject
            {
                ["asset_layout"] = bodyObject
            };

            return wrapper;
        }

        public static JObject BuildAssetJson(object body, HuduAssetField[]? fields = null)
        {
            JObject bodyObject = body.ConvertToJObject();

            bodyObject["custom_fields"] = JArray.FromObject(fields ?? Array.Empty<HuduAssetField>());

            var wrapper = new JObject
            {
                ["asset"] = bodyObject
            };

            return wrapper;
        }
    }
}
