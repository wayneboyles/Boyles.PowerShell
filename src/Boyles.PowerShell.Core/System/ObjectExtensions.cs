using System.Collections;

using Newtonsoft.Json.Linq;

namespace System
{
    public static class ObjectExtensions
    {
        public static JObject ConvertToJObject(this object body)
        {
            if (body is JObject jObj)
            {
                return jObj;
            }

            if (body is IDictionary dictionary)
            {
                var jo = new JObject();

                foreach (DictionaryEntry entry in dictionary)
                {
                    jo[entry.Key.ToString()!] = entry.Value == null ? JValue.CreateNull() : JToken.FromObject(entry.Value);
                }

                return jo;
            }

            // Fallback for POCOs or anything else that lands here
            return JObject.FromObject(body);
        }
    }
}
