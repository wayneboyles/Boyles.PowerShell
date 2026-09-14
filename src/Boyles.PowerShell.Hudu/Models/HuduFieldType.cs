namespace Boyles.PowerShell.Hudu.Models
{
    /// <summary>
    /// Wire values accepted by Hudu for the <c>field_type</c> property of an asset layout field.
    /// </summary>
    /// <remarks>
    /// Hudu transmits these as free-form strings rather than a closed enumeration, and new types are
    /// introduced between releases. They are modelled as constants so that an unrecognised value round
    /// trips unchanged instead of failing deserialisation.
    /// </remarks>
    public static class HuduFieldType {
        /// <summary>
        /// A single line plain text box.
        /// </summary>
        public const string Text = "Text";

        /// <summary>
        /// A multi line formatted text editor. Values are stored as HTML.
        /// </summary>
        public const string RichText = "RichText";

        /// <summary>
        /// A display-only separator. Carries no value on an asset.
        /// </summary>
        public const string Heading = "Heading";

        /// <summary>
        /// A boolean checkbox.
        /// </summary>
        public const string CheckBox = "CheckBox";

        /// <summary>
        /// A URL, rendered by Hudu as a hyperlink.
        /// </summary>
        public const string Website = "Website";

        /// <summary>
        /// A masked secret. Values are write-only for non-privileged API keys.
        /// </summary>
        public const string Password = "Password";

        /// <summary>
        /// An email address.
        /// </summary>
        public const string Email = "Email";

        /// <summary>
        /// A telephone number.
        /// </summary>
        public const string Phone = "Phone";

        /// <summary>
        /// A numeric value.
        /// </summary>
        public const string Number = "Number";

        /// <summary>
        /// A calendar date. Values are exchanged in ISO 8601 <c>yyyy-MM-dd</c> form.
        /// </summary>
        public const string Date = "Date";

        /// <summary>
        /// A single selection from a fixed option list.
        /// </summary>
        public const string Dropdown = "Dropdown";

        /// <summary>
        /// A multiple selection from a fixed option list.
        /// </summary>
        public const string ListSelect = "ListSelect";

        /// <summary>
        /// An embedded external document or media frame.
        /// </summary>
        public const string Embed = "Embed";

        /// <summary>
        /// A relation to one or more other assets. Values are exchanged as arrays of asset identifiers.
        /// </summary>
        public const string AssetTag = "AssetTag";

        /// <summary>
        /// Determines whether the supplied field type stores a value against an asset.
        /// </summary>
        /// <param name="fieldType">
        /// The field type to test. Comparison is case insensitive.
        /// </param>
        /// <returns>
        /// <see langword="false"/> for presentation-only types such as <see cref="Heading"/>; otherwise
        /// <see langword="true"/>.
        /// </returns>
        public static bool IsValueBearing(string? fieldType) {
            return !string.Equals(fieldType, Heading, System.StringComparison.OrdinalIgnoreCase);
        }
    }
}
