using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.TestClient.Utils
{
    /// <summary>
    /// Editable view-model for one row of the AssetLayouts field editor. Mirrors
    /// <see cref="HuduAssetLayoutField"/> but with a stable <see cref="Key"/> for use as a Blazor
    /// list/element key, and drops <see cref="HuduAssetLayoutField.Id"/> since these forms only
    /// ever submit the field set wholesale (Hudu preserves existing ids by matching label).
    /// </summary>
    public sealed class AssetLayoutFieldRow
    {
        public Guid Key { get; } = Guid.NewGuid();

        public string Label { get; set; } = string.Empty;

        public string FieldType { get; set; } = HuduFieldType.Text;

        public bool Required { get; set; }

        public bool ShowInList { get; set; }

        public string? Hint { get; set; }

        public string? Options { get; set; }

        public int? Min { get; set; }

        public int? Max { get; set; }

        public HuduAssetLayoutField ToField(int position) => new()
        {
            Label = Label,
            FieldType = FieldType,
            Position = position,
            Required = Required,
            ShowInList = ShowInList,
            Hint = string.IsNullOrWhiteSpace(Hint) ? null : Hint,
            Options = string.IsNullOrWhiteSpace(Options) ? null : Options,
            Min = Min,
            Max = Max,
        };

        public static AssetLayoutFieldRow FromField(HuduAssetLayoutField field) => new()
        {
            Label = field.Label ?? string.Empty,
            FieldType = field.FieldType ?? HuduFieldType.Text,
            Required = field.Required ?? false,
            ShowInList = field.ShowInList ?? false,
            Hint = field.Hint,
            Options = field.Options,
            Min = field.Min,
            Max = field.Max,
        };
    }
}
