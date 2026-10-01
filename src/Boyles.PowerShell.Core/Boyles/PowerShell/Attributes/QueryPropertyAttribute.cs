namespace Boyles.PowerShell.Attributes
{
    /// <summary>
    /// Marks a PowerShell parameter with the query-string key it should be written to when
    /// ConvertTo-RequestQuery builds a query hashtable. Used where the parameter's PowerShell
    /// name (PascalCase) differs from the API's query key (typically snake_case),
    /// e.g. [QueryProperty('company_id')] on a CompanyId parameter.
    /// </summary>
    [AttributeUsage(AttributeTargets.Parameter, AllowMultiple = false, Inherited = false)]
    public sealed class QueryPropertyAttribute : Attribute
    {
        /// <summary>
        /// The query-string key to emit for this parameter.
        /// </summary>
        public string Name { get; }

        /// <summary>
        /// Initializes a new instance of the QueryPropertyAttribute class.
        /// </summary>
        /// <param name="name">The query-string key to use in place of the parameter's PowerShell name.</param>
        /// <exception cref="ArgumentException"><paramref name="name"/> is null, empty, or whitespace.</exception>
        public QueryPropertyAttribute(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                throw new ArgumentException("name is required", nameof(name));
            }

            Name = name;
        }
    }
}
