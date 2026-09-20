namespace Boyles.PowerShell.Attributes
{
    /// <summary>
    /// Marks a PowerShell parameter to be excluded from request bodies built by
    /// ConvertTo-RequestBody, even though it is bound and has a value. Used for parameters
    /// that belong in the URL path or query string rather than the JSON body, e.g. -Id on a
    /// Set-* cmdlet.
    /// </summary>
    [AttributeUsage(AttributeTargets.Parameter, AllowMultiple = false, Inherited = false)]
    public sealed class BodyIgnoreAttribute : Attribute
    {
    }
}
