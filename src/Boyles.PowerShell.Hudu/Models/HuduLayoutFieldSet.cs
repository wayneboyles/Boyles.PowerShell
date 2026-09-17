using System.Globalization;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A fluently composable collection of asset layout field definitions.
    /// </summary>
    /// <remarks>
    /// Positions are assigned automatically in the order fields are added, starting at one, so that a
    /// layout can be declared without tracking ordinals by hand. An explicit position may still be set
    /// on the returned definitions after <see cref="Build"/>.
    /// </remarks>
    public sealed class HuduLayoutFieldSet {
        /// <summary>
        /// The accumulated field definitions, in declaration order.
        /// </summary>
        private readonly List<HuduAssetLayoutField> _fields;

        /// <summary>
        /// Initialises a new, empty layout field set.
        /// </summary>
        public HuduLayoutFieldSet() {
            _fields = new List<HuduAssetLayoutField>();
        }

        /// <summary>
        /// The number of field definitions accumulated so far.
        /// </summary>
        public int Count {
            get { return _fields.Count; }
        }

        /// <summary>
        /// Creates a new, empty layout field set.
        /// </summary>
        /// <returns>
        /// A new <see cref="HuduLayoutFieldSet"/>.
        /// </returns>
        public static HuduLayoutFieldSet Create() {
            return new HuduLayoutFieldSet();
        }

        /// <summary>
        /// Appends a field definition of an arbitrary type.
        /// </summary>
        /// <param name="label">
        /// The human readable field label.
        /// </param>
        /// <param name="fieldType">
        /// The field type, ordinarily one of the constants on <see cref="HuduFieldType"/>.
        /// </param>
        /// <param name="required">
        /// Whether the field must be populated before an asset can be saved.
        /// </param>
        /// <param name="showInList">
        /// Whether the field appears as a column in asset list views.
        /// </param>
        /// <param name="hint">
        /// Optional helper text displayed beneath the field.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet Add(string label, string fieldType, bool required = false, bool showInList = false, string? hint = null) {
            if (string.IsNullOrWhiteSpace(label)) {
                throw new ArgumentException("Field label must not be empty.", nameof(label));
            }

            _fields.Add(new HuduAssetLayoutField {
                Label = label,
                FieldType = fieldType,
                Position = _fields.Count + 1,
                Required = required,
                ShowInList = showInList,
                Hint = hint
            });

            return this;
        }

        /// <summary>
        /// Appends a single line text field.
        /// </summary>
        /// <param name="label">
        /// The human readable field label.
        /// </param>
        /// <param name="required">
        /// Whether the field must be populated before an asset can be saved.
        /// </param>
        /// <param name="showInList">
        /// Whether the field appears as a column in asset list views.
        /// </param>
        /// <param name="hint">
        /// Optional helper text displayed beneath the field.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet AddText(string label, bool required = false, bool showInList = false, string? hint = null) {
            return Add(label, HuduFieldType.Text, required, showInList, hint);
        }

        /// <summary>
        /// Appends a formatted multi line text field.
        /// </summary>
        /// <param name="label">
        /// The human readable field label.
        /// </param>
        /// <param name="required">
        /// Whether the field must be populated before an asset can be saved.
        /// </param>
        /// <param name="hint">
        /// Optional helper text displayed beneath the field.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet AddRichText(string label, bool required = false, string? hint = null) {
            return Add(label, HuduFieldType.RichText, required, false, hint);
        }

        /// <summary>
        /// Appends a display-only heading used to separate groups of fields.
        /// </summary>
        /// <param name="label">
        /// The heading text.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet AddHeading(string label) {
            return Add(label, HuduFieldType.Heading);
        }

        /// <summary>
        /// Appends a boolean checkbox field.
        /// </summary>
        /// <param name="label">
        /// The human readable field label.
        /// </param>
        /// <param name="showInList">
        /// Whether the field appears as a column in asset list views.
        /// </param>
        /// <param name="hint">
        /// Optional helper text displayed beneath the field.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet AddCheckBox(string label, bool showInList = false, string? hint = null) {
            return Add(label, HuduFieldType.CheckBox, false, showInList, hint);
        }

        /// <summary>
        /// Appends a numeric field with optional bounds.
        /// </summary>
        /// <param name="label">
        /// The human readable field label.
        /// </param>
        /// <param name="min">
        /// The optional minimum accepted value.
        /// </param>
        /// <param name="max">
        /// The optional maximum accepted value.
        /// </param>
        /// <param name="required">
        /// Whether the field must be populated before an asset can be saved.
        /// </param>
        /// <param name="showInList">
        /// Whether the field appears as a column in asset list views.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet AddNumber(string label, int? min = null, int? max = null, bool required = false, bool showInList = false) {
            Add(label, HuduFieldType.Number, required, showInList);
            _fields[_fields.Count - 1].Min = min;
            _fields[_fields.Count - 1].Max = max;
            return this;
        }

        /// <summary>
        /// Appends a date field, optionally participating in expiration tracking.
        /// </summary>
        /// <param name="label">
        /// The human readable field label.
        /// </param>
        /// <param name="expiration">
        /// Whether values in this field should drive Hudu's expiration reporting.
        /// </param>
        /// <param name="required">
        /// Whether the field must be populated before an asset can be saved.
        /// </param>
        /// <param name="showInList">
        /// Whether the field appears as a column in asset list views.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet AddDate(string label, bool expiration = false, bool required = false, bool showInList = false) {
            Add(label, HuduFieldType.Date, required, showInList);
            _fields[_fields.Count - 1].Expiration = expiration;
            return this;
        }

        /// <summary>
        /// Appends a single selection dropdown field.
        /// </summary>
        /// <param name="label">
        /// The human readable field label.
        /// </param>
        /// <param name="options">
        /// The selectable options, which are joined with newlines for transmission.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet AddDropdown(string label, params string[] options) {
            Add(label, HuduFieldType.Dropdown);
            _fields[_fields.Count - 1].Options = JoinOptions(options);
            return this;
        }

        /// <summary>
        /// Appends a multiple selection list field.
        /// </summary>
        /// <param name="label">
        /// The human readable field label.
        /// </param>
        /// <param name="options">
        /// The selectable options, which are joined with newlines for transmission.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet AddListSelect(string label, params string[] options) {
            Add(label, HuduFieldType.ListSelect);
            _fields[_fields.Count - 1].Options = JoinOptions(options);
            return this;
        }

        /// <summary>
        /// Appends a relation field linking to assets of another layout.
        /// </summary>
        /// <param name="label">
        /// The human readable field label.
        /// </param>
        /// <param name="linkableId">
        /// The identifier of the asset layout whose assets may be selected.
        /// </param>
        /// <param name="showInList">
        /// Whether the field appears as a column in asset list views.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet AddAssetTag(string label, int linkableId, bool showInList = false) {
            Add(label, HuduFieldType.AssetTag, false, showInList);
            _fields[_fields.Count - 1].LinkableId = linkableId;
            return this;
        }

        /// <summary>
        /// Appends a password field.
        /// </summary>
        /// <param name="label">
        /// The human readable field label.
        /// </param>
        /// <param name="hint">
        /// Optional helper text displayed beneath the field.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet AddPassword(string label, string? hint = null) {
            return Add(label, HuduFieldType.Password, false, false, hint);
        }

        /// <summary>
        /// Appends a website, email or telephone field.
        /// </summary>
        /// <param name="label">
        /// The human readable field label.
        /// </param>
        /// <param name="fieldType">
        /// One of <see cref="HuduFieldType.Website"/>, <see cref="HuduFieldType.Email"/> or
        /// <see cref="HuduFieldType.Phone"/>.
        /// </param>
        /// <param name="showInList">
        /// Whether the field appears as a column in asset list views.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduLayoutFieldSet AddContact(string label, string fieldType, bool showInList = false) {
            return Add(label, fieldType, false, showInList);
        }

        /// <summary>
        /// Materialises the accumulated definitions.
        /// </summary>
        /// <returns>
        /// The field definitions, positioned in declaration order.
        /// </returns>
        public HuduAssetLayoutField[] Build() {
            return _fields.ToArray();
        }

        /// <summary>
        /// Returns a compact summary of the field count for diagnostic output.
        /// </summary>
        /// <returns>
        /// A short description of the set.
        /// </returns>
        public override string ToString() {
            return string.Format(CultureInfo.InvariantCulture, "HuduLayoutFieldSet ({0} field(s))", _fields.Count);
        }

        /// <summary>
        /// Joins selectable options into the newline delimited form Hudu expects.
        /// </summary>
        /// <param name="options">
        /// The options to join.
        /// </param>
        /// <returns>
        /// The joined options, or <see langword="null"/> when none were supplied.
        /// </returns>
        private static string? JoinOptions(string[]? options) {
            if (options == null || options.Length == 0) {
                return null;
            }

            return string.Join("\n", options);
        }
    }
}
