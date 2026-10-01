namespace Boyles.PowerShell.Attributes
{
    /// <summary>
    /// Marks a PowerShell parameter to be excluded from request query strings built by
    /// ConvertTo-RequestQuery, even though it is bound and has a value. Used for parameters
    /// that belong in the URL path or request body rather than the query string, e.g. -Id on a
    /// Get-* cmdlet that fetches a single item.
    /// </summary>
    [AttributeUsage(AttributeTargets.Parameter, AllowMultiple = false, Inherited = false)]
    public sealed class QueryIgnoreAttribute : Attribute
    {
    }
}
