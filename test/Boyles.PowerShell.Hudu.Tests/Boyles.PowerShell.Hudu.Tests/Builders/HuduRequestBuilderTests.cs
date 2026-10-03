using Boyles.PowerShell.Hudu.Models;

using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.Hudu.Builders
{
    /// <summary>
    /// Verifies that <see cref="HuduRequestBuilder"/> wraps request bodies in the envelope Hudu expects
    /// and shapes each child item correctly.
    /// </summary>
    public class HuduRequestBuilderTests
    {
        #region BuildAssetJson

        /// <summary>
        /// The asset body must sit under a single <c>asset</c> root, with the caller's properties alongside <c>custom_fields</c>.
        /// </summary>
        [Fact]
        public void BuildAssetJson_WrapsBodyInAssetEnvelope()
        {
            var body = new Dictionary<string, object?> { ["name"] = "SRV-01", ["company_id"] = 7 };

            JObject result = HuduRequestBuilder.BuildAssetJson(body, []);

            var root = Assert.Single(result.Properties());
            Assert.Equal("asset", root.Name);

            var asset = Assert.IsType<JObject>(root.Value);
            Assert.Equal("SRV-01", asset.Value<string>("name"));
            Assert.Equal(7, asset.Value<int>("company_id"));
            Assert.IsType<JArray>(asset["custom_fields"]);
        }

        /// <summary>
        /// Each custom field must be its own single-key object keyed by the normalized label.
        /// </summary>
        [Fact]
        public void BuildAssetJson_ProjectsFieldsAsSingleKeyObjectsUsingWireKey()
        {
            HuduAssetField[] fields =
            [
                new() { Label = "Serial Number", Value = "ABC123" },
                new() { Label = "Warranty  Expires!", Value = "2027-01-31" },
                new() { Label = "Rack Units", Value = 2 }
            ];

            JObject result = HuduRequestBuilder.BuildAssetJson(new Dictionary<string, object?> { ["name"] = "x" }, fields);

            var customFields = (JArray)result["asset"]!["custom_fields"]!;
            Assert.Equal(3, customFields.Count);

            Assert.All(customFields, item => Assert.Single(Assert.IsType<JObject>(item).Properties()));
            Assert.Equal("ABC123", customFields[0]["serial_number"]!.Value<string>());
            Assert.Equal("2027-01-31", customFields[1]["warranty_expires"]!.Value<string>());
            Assert.Equal(2, customFields[2]["rack_units"]!.Value<int>());
        }

        /// <summary>
        /// A field with a null value must still be sent, as an explicit JSON null, so Hudu clears it.
        /// </summary>
        [Fact]
        public void BuildAssetJson_NullFieldValue_IsWrittenAsJsonNull()
        {
            HuduAssetField[] fields = [new() { Label = "Notes", Value = null }];

            JObject result = HuduRequestBuilder.BuildAssetJson(new Dictionary<string, object?>(), fields);

            var customFields = (JArray)result["asset"]!["custom_fields"]!;
            var single = Assert.Single(customFields);
            Assert.Equal(JTokenType.Null, single["notes"]!.Type);
        }

        /// <summary>
        /// Fields that have no usable label cannot be keyed, so they are skipped.
        /// </summary>
        [Theory]
        [InlineData(null)]
        [InlineData("")]
        [InlineData("   ")]
        [InlineData("!!!")]
        public void BuildAssetJson_FieldWithoutWireKey_IsSkipped(string? label)
        {
            HuduAssetField[] fields =
            [
                new() { Label = label, Value = "ignored" },
                new() { Label = "Kept", Value = "yes" }
            ];

            JObject result = HuduRequestBuilder.BuildAssetJson(new Dictionary<string, object?>(), fields);

            var customFields = (JArray)result["asset"]!["custom_fields"]!;
            var single = Assert.Single(customFields);
            Assert.Equal("yes", single["kept"]!.Value<string>());
        }

        /// <summary>
        /// With no fields supplied, <c>custom_fields</c> is an empty array rather than missing.
        /// </summary>
        [Fact]
        public void BuildAssetJson_NullFields_WritesEmptyCustomFieldsArray()
        {
            JObject result = HuduRequestBuilder.BuildAssetJson(new Dictionary<string, object?> { ["name"] = "x" });

            var customFields = Assert.IsType<JArray>(result["asset"]!["custom_fields"]);
            Assert.Empty(customFields);
        }

        /// <summary>
        /// Array-valued fields (asset tags, list selects) must keep their array shape.
        /// </summary>
        [Fact]
        public void BuildAssetJson_ArrayFieldValue_IsPreservedAsJsonArray()
        {
            HuduAssetField[] fields = [new() { Label = "Linked Assets", Value = new[] { 1, 2, 3 } }];

            JObject result = HuduRequestBuilder.BuildAssetJson(new Dictionary<string, object?>(), fields);

            var value = Assert.IsType<JArray>(result["asset"]!["custom_fields"]![0]!["linked_assets"]);
            Assert.Equal(new[] { 1, 2, 3 }, value.Select(t => t.Value<int>()));
        }

        #endregion

        #region BuildAssetLayoutJson

        /// <summary>
        /// The layout body must sit under a single <c>asset_layout</c> root with its <c>fields</c> array.
        /// </summary>
        [Fact]
        public void BuildAssetLayoutJson_WrapsBodyAndFieldsInAssetLayoutEnvelope()
        {
            var body = new Dictionary<string, object?> { ["name"] = "Servers", ["icon"] = "fas fa-server" };
            HuduAssetLayoutField[] fields =
            [
                new() { Label = "Hostname", FieldType = "Text", Position = 1, Required = true, ShowInList = true },
                new() { Label = "Notes", FieldType = "RichText", Position = 2 }
            ];

            JObject result = HuduRequestBuilder.BuildAssetLayoutJson(body, fields);

            var root = Assert.Single(result.Properties());
            Assert.Equal("asset_layout", root.Name);

            var layout = Assert.IsType<JObject>(root.Value);
            Assert.Equal("Servers", layout.Value<string>("name"));
            Assert.Equal("fas fa-server", layout.Value<string>("icon"));

            var layoutFields = Assert.IsType<JArray>(layout["fields"]);
            Assert.Equal(2, layoutFields.Count);
            Assert.Equal("Hostname", layoutFields[0]["label"]!.Value<string>());
            Assert.Equal("Text", layoutFields[0]["field_type"]!.Value<string>());
            Assert.Equal(1, layoutFields[0]["position"]!.Value<int>());
            Assert.True(layoutFields[0]["required"]!.Value<bool>());
            Assert.Equal("RichText", layoutFields[1]["field_type"]!.Value<string>());
        }

        /// <summary>
        /// Hudu replaces the whole field list when <c>fields</c> is present, so a null list must omit the key entirely.
        /// </summary>
        [Fact]
        public void BuildAssetLayoutJson_NullFields_OmitsFieldsKey()
        {
            JObject result = HuduRequestBuilder.BuildAssetLayoutJson(new Dictionary<string, object?> { ["name"] = "Servers" });

            var layout = (JObject)result["asset_layout"]!;
            Assert.False(layout.ContainsKey("fields"));
            Assert.Equal("Servers", layout.Value<string>("name"));
        }

        /// <summary>
        /// An explicit empty list is a deliberate "clear all fields" and must be sent as an empty array.
        /// </summary>
        [Fact]
        public void BuildAssetLayoutJson_EmptyFields_WritesEmptyArray()
        {
            JObject result = HuduRequestBuilder.BuildAssetLayoutJson(new Dictionary<string, object?>(), []);

            var fields = Assert.IsType<JArray>(result["asset_layout"]!["fields"]);
            Assert.Empty(fields);
        }

        /// <summary>
        /// Optional layout field properties that are null are left off the wire.
        /// </summary>
        [Fact]
        public void BuildAssetLayoutJson_OmitsNullOptionalFieldProperties()
        {
            HuduAssetLayoutField[] fields = [new() { Label = "Hostname", FieldType = "Text" }];

            JObject result = HuduRequestBuilder.BuildAssetLayoutJson(new Dictionary<string, object?>(), fields);

            var field = (JObject)result["asset_layout"]!["fields"]![0]!;
            Assert.False(field.ContainsKey("hint"));
            Assert.False(field.ContainsKey("options"));
            Assert.False(field.ContainsKey("linkable_id"));
        }

        #endregion

        #region BuildListJson

        /// <summary>
        /// The list body must sit under a single <c>list</c> root with <c>list_items_attributes</c>.
        /// </summary>
        [Fact]
        public void BuildListJson_WrapsBodyAndItemsInListEnvelope()
        {
            var body = new Dictionary<string, object?> { ["name"] = "Vendors" };
            HuduListItem[] items =
            [
                new() { Id = 10, Name = "Aruba" },
                new() { Name = "Ubiquiti" }
            ];

            JObject result = HuduRequestBuilder.BuildListJson(body, items);

            var root = Assert.Single(result.Properties());
            Assert.Equal("list", root.Name);

            var list = Assert.IsType<JObject>(root.Value);
            Assert.Equal("Vendors", list.Value<string>("name"));

            var children = Assert.IsType<JArray>(list["list_items_attributes"]);
            Assert.Equal(2, children.Count);
            Assert.Equal(10, children[0]["id"]!.Value<int>());
            Assert.Equal("Aruba", children[0]["name"]!.Value<string>());
            Assert.Equal("Ubiquiti", children[1]["name"]!.Value<string>());
        }

        /// <summary>
        /// New items have no id yet; the key must be absent rather than null so Hudu creates them.
        /// </summary>
        [Fact]
        public void BuildListJson_ItemWithoutId_OmitsIdKey()
        {
            JObject result = HuduRequestBuilder.BuildListJson(
                new Dictionary<string, object?>(),
                [new HuduListItem { Name = "New" }]);

            var item = (JObject)result["list"]!["list_items_attributes"]![0]!;
            Assert.False(item.ContainsKey("id"));
            Assert.Equal("New", item.Value<string>("name"));
        }

        /// <summary>
        /// Items without a name are meaningless to Hudu and are dropped.
        /// </summary>
        [Theory]
        [InlineData(null)]
        [InlineData("")]
        [InlineData("  ")]
        public void BuildListJson_ItemWithoutName_IsSkipped(string? name)
        {
            HuduListItem[] items =
            [
                new() { Id = 1, Name = name },
                new() { Id = 2, Name = "Kept" }
            ];

            JObject result = HuduRequestBuilder.BuildListJson(new Dictionary<string, object?>(), items);

            var children = (JArray)result["list"]!["list_items_attributes"]!;
            var single = Assert.Single(children);
            Assert.Equal("Kept", single.Value<string>("name"));
        }

        /// <summary>
        /// With no items supplied, <c>list_items_attributes</c> is an empty array rather than missing.
        /// </summary>
        [Fact]
        public void BuildListJson_NullItems_WritesEmptyArray()
        {
            JObject result = HuduRequestBuilder.BuildListJson(new Dictionary<string, object?> { ["name"] = "Empty" });

            var children = Assert.IsType<JArray>(result["list"]!["list_items_attributes"]);
            Assert.Empty(children);
        }

        #endregion

        #region Body handling

        /// <summary>
        /// A JObject body (as produced by the cmdlet layer) is accepted and its properties are retained.
        /// </summary>
        [Fact]
        public void Builders_AcceptJObjectBody()
        {
            var body = new JObject { ["name"] = "From JObject" };

            JObject result = HuduRequestBuilder.BuildAssetJson(body, []);

            Assert.Equal("From JObject", result["asset"]!.Value<string>("name"));
        }

        /// <summary>
        /// A plain object body is serialized into the envelope.
        /// </summary>
        [Fact]
        public void Builders_AcceptPlainObjectBody()
        {
            JObject result = HuduRequestBuilder.BuildListJson(new { name = "From POCO" }, []);

            Assert.Equal("From POCO", result["list"]!.Value<string>("name"));
        }

        /// <summary>
        /// A null entry in a hashtable body stays in the payload as a JSON null.
        /// </summary>
        [Fact]
        public void Builders_PreserveNullBodyValues()
        {
            var body = new Dictionary<string, object?> { ["archived_at"] = null };

            JObject result = HuduRequestBuilder.BuildAssetJson(body, []);

            Assert.Equal(JTokenType.Null, result["asset"]!["archived_at"]!.Type);
        }

        #endregion
    }
}
