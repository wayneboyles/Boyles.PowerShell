namespace Boyles.PowerShell.Attributes
{
    /// <summary>
    /// Marks a PowerShell parameter to be excluded from request querystrings built by
    /// ConvertTo-RequestQuery, even though it is bound and has a value. 
    /// </summary>
    [AttributeUsage(AttributeTargets.Parameter, AllowMultiple = false, Inherited = false)]
    public sealed class QueryIgnoreAttribute : Attribute
    {
    }
}
