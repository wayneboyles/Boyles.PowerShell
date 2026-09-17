using System.Collections;
using System.Globalization;
using System.Text;

namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// A mutable, fluently composable set of Hudu custom field values, keyed by snake cased field label.
    /// </summary>
    /// <remarks>
    /// <para>
    /// Hudu is asymmetric about custom fields. Reads return a <c>fields</c> array of labelled objects,
    /// whereas writes expect a <c>custom_fields</c> array containing exactly one object whose keys are
    /// the snake cased field labels. This type absorbs that asymmetry: it can be seeded from a
    /// <see cref="HuduAsset"/> read response and rendered into the write payload via
    /// <see cref="ToPayload"/>.
    /// </para>
    /// <para>
    /// Value coercion is applied on assignment so that callers may pass native types. Dates are
    /// rendered as ISO 8601 <c>yyyy-MM-dd</c>, booleans as JSON booleans, and asset relations as arrays
    /// of asset identifiers.
    /// </para>
    /// </remarks>
    public sealed class HuduFieldSet 
    {
        /// <summary>
        /// The backing store, keyed by normalised label. Insertion order is not preserved by Hudu and is
        /// not relied upon here.
        /// </summary>
        private readonly Dictionary<string, object?> _values;

        /// <summary>
        /// Initialises a new, empty field set.
        /// </summary>
        public HuduFieldSet() {
            _values = new Dictionary<string, object?>(StringComparer.Ordinal);
        }

        /// <summary>
        /// The number of fields currently held in the set.
        /// </summary>
        public int Count {
            get { return _values.Count; }
        }

        /// <summary>
        /// The normalised wire keys currently held in the set.
        /// </summary>
        public string[] Keys {
            get { return _values.Keys.ToArray(); }
        }

        /// <summary>
        /// Gets or sets a field value by label. Setting applies the same coercion as
        /// <see cref="Set(string, object)"/>.
        /// </summary>
        /// <param name="label">
        /// The field label, in either human readable or snake cased form.
        /// </param>
        /// <returns>
        /// The coerced value, or <see langword="null"/> when the field is not present.
        /// </returns>
        public object? this[string label] {
            get {
                string key = NormalizeLabel(label);
                object? value;
                return _values.TryGetValue(key, out value) ? value : null;
            }

            set { Set(label, value); }
        }

        /// <summary>
        /// Creates a new, empty field set.
        /// </summary>
        /// <returns>
        /// A new <see cref="HuduFieldSet"/>.
        /// </returns>
        /// <remarks>
        /// Provided as a fluent entry point so a chain can begin with a static call rather than a
        /// constructor expression.
        /// </remarks>
        public static HuduFieldSet Create() {
            return new HuduFieldSet();
        }

        /// <summary>
        /// Creates a field set from a dictionary of label and value pairs.
        /// </summary>
        /// <param name="values">
        /// The source values. The non generic <see cref="IDictionary"/> is accepted so that a PowerShell
        /// hashtable binds directly.
        /// </param>
        /// <returns>
        /// A new <see cref="HuduFieldSet"/> containing the coerced values.
        /// </returns>
        public static HuduFieldSet FromDictionary(IDictionary values) {
            HuduFieldSet set = new HuduFieldSet();
            if (values == null) {
                return set;
            }

            foreach (DictionaryEntry entry in values) {
                string? label = entry.Key?.ToString();
                if (!string.IsNullOrWhiteSpace(label)) {
                    set.Set(label!, entry.Value);
                }
            }

            return set;
        }

        /// <summary>
        /// Creates a field set seeded with the current field values of an existing asset.
        /// </summary>
        /// <param name="asset">
        /// The asset whose fields should be copied. Presentation-only fields such as headings are
        /// skipped.
        /// </param>
        /// <returns>
        /// A new <see cref="HuduFieldSet"/> reflecting the asset's current state.
        /// </returns>
        /// <remarks>
        /// Seeding from the asset is the supported way to perform a partial update, because a Hudu asset
        /// write replaces the custom card wholesale rather than merging field by field.
        /// </remarks>
        public static HuduFieldSet FromAsset(HuduAsset asset) {
            HuduFieldSet set = new HuduFieldSet();
            if (asset == null) {
                return set;
            }

            foreach (HuduAssetField field in asset.Fields) {
                if (!HuduFieldType.IsValueBearing(field.FieldType)) {
                    continue;
                }

                string key = field.WireKey;
                if (key.Length > 0) {
                    set._values[key] = field.Value;
                }
            }

            return set;
        }

        /// <summary>
        /// Converts a human readable field label into the snake cased key Hudu expects on the wire.
        /// </summary>
        /// <param name="label">
        /// The label to normalise. Already normalised input is returned unchanged.
        /// </param>
        /// <returns>
        /// The lower cased, underscore separated wire key, or an empty string when the label yields no
        /// usable characters.
        /// </returns>
        /// <remarks>
        /// Runs of non alphanumeric characters collapse to a single underscore and leading or trailing
        /// underscores are trimmed, so both <c>"Warranty Expires"</c> and <c>"Warranty  Expires!"</c>
        /// produce <c>warranty_expires</c>.
        /// </remarks>
        public static string NormalizeLabel(string? label) {
            if (string.IsNullOrWhiteSpace(label)) {
                return string.Empty;
            }

            StringBuilder builder = new StringBuilder(label!.Length);
            bool pendingSeparator = false;

            foreach (char character in label!) {
                if (char.IsLetterOrDigit(character)) {
                    if (pendingSeparator && builder.Length > 0) {
                        builder.Append('_');
                    }

                    builder.Append(char.ToLowerInvariant(character));
                    pendingSeparator = false;
                }
                else {
                    pendingSeparator = true;
                }
            }

            return builder.ToString();
        }

        /// <summary>
        /// Sets a field value, coercing common .NET types into their Hudu wire representation.
        /// </summary>
        /// <param name="label">
        /// The field label, in either human readable or snake cased form.
        /// </param>
        /// <param name="value">
        /// The value to store. A <see langword="null"/> value clears the field on the next write.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduFieldSet Set(string label, object? value) {
            string key = NormalizeLabel(label);
            if (key.Length == 0) {
                throw new ArgumentException("Field label must contain at least one alphanumeric character.", nameof(label));
            }

            _values[key] = Coerce(value);
            return this;
        }

        /// <summary>
        /// Sets a field value only when the supplied value is neither null nor an empty string.
        /// </summary>
        /// <param name="label">
        /// The field label, in either human readable or snake cased form.
        /// </param>
        /// <param name="value">
        /// The candidate value.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        /// <remarks>
        /// Useful when composing a payload from optional upstream data, where an absent value should
        /// leave the existing Hudu content untouched rather than blanking it.
        /// </remarks>
        public HuduFieldSet SetIfPresent(string label, object? value) {
            if (value == null) {
                return this;
            }

            string? text = value as string;
            if (text != null && text.Length == 0) {
                return this;
            }

            return Set(label, value);
        }

        /// <summary>
        /// Sets a plain text, rich text, website, email or phone field.
        /// </summary>
        /// <param name="label">
        /// The field label.
        /// </param>
        /// <param name="value">
        /// The text to store.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduFieldSet SetText(string label, string? value) {
            return Set(label, value);
        }

        /// <summary>
        /// Sets a numeric field.
        /// </summary>
        /// <param name="label">
        /// The field label.
        /// </param>
        /// <param name="value">
        /// The number to store.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduFieldSet SetNumber(string label, decimal? value) {
            return Set(label, value);
        }

        /// <summary>
        /// Sets a checkbox field.
        /// </summary>
        /// <param name="label">
        /// The field label.
        /// </param>
        /// <param name="value">
        /// The boolean state to store.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduFieldSet SetCheckBox(string label, bool value) {
            return Set(label, value);
        }

        /// <summary>
        /// Sets a date field, discarding any time component.
        /// </summary>
        /// <param name="label">
        /// The field label.
        /// </param>
        /// <param name="value">
        /// The date to store.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduFieldSet SetDate(string label, DateTime? value) {
            return Set(label, value);
        }

        /// <summary>
        /// Sets a dropdown field to a single option.
        /// </summary>
        /// <param name="label">
        /// The field label.
        /// </param>
        /// <param name="option">
        /// The option text, which must match one of the options configured on the asset layout.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduFieldSet SetDropdown(string label, string? option) {
            return Set(label, option);
        }

        /// <summary>
        /// Sets a multi select field to zero or more options.
        /// </summary>
        /// <param name="label">
        /// The field label.
        /// </param>
        /// <param name="options">
        /// The option texts, each of which must match an option configured on the asset layout.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduFieldSet SetListSelect(string label, params string[] options) {
            return Set(label, options ?? Array.Empty<string>());
        }

        /// <summary>
        /// Sets an asset relation field to zero or more related assets.
        /// </summary>
        /// <param name="label">
        /// The field label.
        /// </param>
        /// <param name="assetIds">
        /// The identifiers of the assets to link. Passing no identifiers clears the relation.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduFieldSet SetAssetTag(string label, params int[] assetIds) {
            return Set(label, assetIds ?? Array.Empty<int>());
        }

        /// <summary>
        /// Copies every value from another field set over the top of this one.
        /// </summary>
        /// <param name="other">
        /// The field set whose values take precedence. A <see langword="null"/> argument is ignored.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduFieldSet Merge(HuduFieldSet? other) {
            if (other == null) {
                return this;
            }

            foreach (KeyValuePair<string, object?> pair in other._values) {
                _values[pair.Key] = pair.Value;
            }

            return this;
        }

        /// <summary>
        /// Removes a field from the set so that it is omitted from the next write.
        /// </summary>
        /// <param name="label">
        /// The field label, in either human readable or snake cased form.
        /// </param>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        /// <remarks>
        /// Removing a field is not the same as clearing it in Hudu. To blank a field, set it to
        /// <see langword="null"/> instead.
        /// </remarks>
        public HuduFieldSet Remove(string label) {
            _values.Remove(NormalizeLabel(label));
            return this;
        }

        /// <summary>
        /// Removes every field from the set.
        /// </summary>
        /// <returns>
        /// This instance, to permit chaining.
        /// </returns>
        public HuduFieldSet Clear() {
            _values.Clear();
            return this;
        }

        /// <summary>
        /// Determines whether a field with the supplied label is present in the set.
        /// </summary>
        /// <param name="label">
        /// The field label, in either human readable or snake cased form.
        /// </param>
        /// <returns>
        /// <see langword="true"/> when the field is present; otherwise <see langword="false"/>.
        /// </returns>
        public bool Contains(string label) {
            return _values.ContainsKey(NormalizeLabel(label));
        }

        /// <summary>
        /// Produces a shallow copy of this field set.
        /// </summary>
        /// <returns>
        /// A new <see cref="HuduFieldSet"/> holding the same values.
        /// </returns>
        public HuduFieldSet Clone() {
            HuduFieldSet copy = new HuduFieldSet();
            copy.Merge(this);
            return copy;
        }

        /// <summary>
        /// Renders the set as the object Hudu expects inside the <c>custom_fields</c> array.
        /// </summary>
        /// <returns>
        /// A dictionary keyed by snake cased field label.
        /// </returns>
        /// <remarks>
        /// The caller is responsible for wrapping the result in a single element array; that wrapping is
        /// performed by <see cref="HttpClients.HuduClient"/>.
        /// </remarks>
        public IDictionary<string, object?> ToPayload() {
            return new Dictionary<string, object?>(_values, StringComparer.Ordinal);
        }

        /// <summary>
        /// Renders the set as a hashtable for inspection from PowerShell.
        /// </summary>
        /// <returns>
        /// A <see cref="Hashtable"/> keyed by snake cased field label.
        /// </returns>
        public Hashtable ToHashtable() {
            Hashtable table = new Hashtable();
            foreach (KeyValuePair<string, object?> pair in _values) {
                table[pair.Key] = pair.Value;
            }

            return table;
        }

        /// <summary>
        /// Returns a compact summary of the field count for diagnostic output.
        /// </summary>
        /// <returns>
        /// A short description of the set.
        /// </returns>
        public override string ToString() {
            return string.Format(CultureInfo.InvariantCulture, "HuduFieldSet ({0} field(s))", _values.Count);
        }

        /// <summary>
        /// Converts a caller supplied value into the representation Hudu accepts on the wire.
        /// </summary>
        /// <param name="value">
        /// The raw value.
        /// </param>
        /// <returns>
        /// The coerced value, ready for serialisation.
        /// </returns>
        private static object? Coerce(object? value) {
            if (value == null) {
                return null;
            }

            if (value is DateTime dateTime) {
                return dateTime.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
            }

            if (value is DateTimeOffset dateTimeOffset) {
                return dateTimeOffset.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
            }

            if (value is bool || value is string) {
                return value;
            }

            if (value is Uri uri) {
                return uri.ToString();
            }

            // A bare enumerable is treated as a multi value field. Arrays are materialised so that
            // deferred PowerShell pipelines are not enumerated twice during serialisation.
            if (value is IEnumerable enumerable) {
                List<object?> items = new List<object?>();
                foreach (object? item in enumerable) {
                    items.Add(Coerce(item));
                }

                return items.ToArray();
            }

            return value;
        }
    }
}
