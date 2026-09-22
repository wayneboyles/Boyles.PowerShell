using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.TestClient.Utils
{
    /// <summary>
    /// Editable view-model for one custom field value row in the Assets new/update demo pages.
    /// Mirrors <see cref="HuduAssetField"/>'s label/value pair, but keeps the value as plain text
    /// for simple editing - writing a field only needs <see cref="HuduAssetField.Label"/> and
    /// <see cref="HuduAssetField.Value"/>.
    /// </summary>
    public sealed class AssetFieldRow
    {
        public Guid Key { get; } = Guid.NewGuid();

        public string Label { get; set; } = string.Empty;

        public string? Value { get; set; }

        public HuduAssetField ToField() => new()
        {
            Label = Label,
            Value = Value,
        };

        public static AssetFieldRow FromField(HuduAssetField field) => new()
        {
            Label = field.Label ?? string.Empty,
            Value = field.Value?.ToString(),
        };
    }
}
