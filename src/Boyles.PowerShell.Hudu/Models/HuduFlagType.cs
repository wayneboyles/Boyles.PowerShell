using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Models
{
    public class HuduFlagType
    {
        [JsonProperty("id")]
        public int? Id { get; set; }

        [JsonProperty("name")]
        public string? Name { get; set; }
    
        [JsonProperty("color")]
        public string? Color { get; set; }
    
        [JsonProperty("slug")]
        public string? Slug  { get; set; }
    }
}