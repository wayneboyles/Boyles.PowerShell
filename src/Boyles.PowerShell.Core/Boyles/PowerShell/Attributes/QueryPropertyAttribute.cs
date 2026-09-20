namespace Boyles.PowerShell.Attributes
{
    /// <summary>
    /// Marks a PowerShell parameter with the JSON property name it should be written to
    /// when ConvertTo-RequestBody builds a request body hashtable. Used where the parameter's
    /// PowerShell name (PascalCase) differs from the API's JSON name (typically snake_case),
    /// e.g. [BodyProperty('passwordable_type')] on a PasswordableType parameter.
    /// </summary>
    [AttributeUsage(AttributeTargets.Parameter, AllowMultiple = false, Inherited = false)]
    public sealed class QueryPropertyAttribute : Attribute
    {
        /// <summary>
        /// The JSON property name to emit in the request body for this parameter.
        /// </summary>
        public string Name { get; }

        /// <summary>
        /// Initializes a new instance of the BodyPropertyAttribute class.
        /// </summary>
        /// <param name="name">The JSON property name to use in place of the parameter's PowerShell name.</param>
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
