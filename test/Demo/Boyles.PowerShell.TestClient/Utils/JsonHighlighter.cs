using System.Text.RegularExpressions;

namespace Boyles.PowerShell.TestClient.Utils
{
    /// <summary>
    /// Renders a JSON (or plain-text) string as HTML with syntax-highlighting spans, for display
    /// inside a dark <c>&lt;pre&gt;</c> code block. Works on already-formatted text (e.g. the
    /// pretty-printed bodies <c>HttpCallRecordBuilder</c> produces) rather than re-parsing it, so
    /// indentation and key order are preserved exactly as captured.
    /// </summary>
    public static class JsonHighlighter
    {
        // Matches, in priority order: a quoted string (optionally followed by its ": " so keys
        // can be told apart from string values), the true/false/null keywords, or a number.
        // Mirrors the classic JS JSON-syntax-highlight regex so keys/strings/keywords/numbers are
        // each captured as one token without a full JSON parse.
        private static readonly Regex TokenPattern = new(
            @"(""(?:\\u[a-fA-F0-9]{4}|\\[^u]|[^\\""])*""(\s*:)?|\b(?:true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)",
            RegexOptions.Compiled);

        /// <summary>
        /// Converts <paramref name="text"/> into HTML: safely escaped, with recognized JSON tokens
        /// wrapped in <c>&lt;span class="json-*"&gt;</c> elements for CSS-driven coloring. Text
        /// that isn't valid JSON is still escaped and returned unhighlighted rather than throwing.
        /// </summary>
        public static string ToHtml(string? text)
        {
            if (string.IsNullOrEmpty(text))
            {
                return string.Empty;
            }

            // Only & < > are escaped (not quotes) so the token regex below can still recognize
            // literal " characters as JSON string delimiters after escaping.
            var escaped = text.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;");

            return TokenPattern.Replace(escaped, Highlight);
        }

        private static string Highlight(Match match)
        {
            var value = match.Value;

            string cssClass;
            if (value.StartsWith('"'))
            {
                cssClass = value.TrimEnd().EndsWith(':') ? "json-key" : "json-string";
            }
            else if (value is "true" or "false")
            {
                cssClass = "json-boolean";
            }
            else if (value == "null")
            {
                cssClass = "json-null";
            }
            else
            {
                cssClass = "json-number";
            }

            return $"<span class=\"{cssClass}\">{value}</span>";
        }
    }
}
