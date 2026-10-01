using System.Collections;

using Newtonsoft.Json.Linq;

namespace System
{
    /// <summary>
    /// Extension methods for converting arbitrary objects into JSON.
    /// </summary>
    public static class ObjectExtensions
    {
        /// <summary>
        /// Converts a request body into a <see cref="JObject"/>. A <see cref="JObject"/> is returned
        /// as-is, an <see cref="IDictionary"/> (e.g. a PowerShell hashtable) is copied key-by-key
        /// with null values preserved as JSON nulls, and anything else is serialized via
        /// <see cref="JObject.FromObject(object)"/>.
        /// </summary>
        /// <param name="body">The object to convert.</param>
        /// <returns>The JSON object representation of <paramref name="body"/>.</returns>
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
