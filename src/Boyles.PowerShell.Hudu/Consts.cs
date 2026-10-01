namespace Boyles.PowerShell.Hudu
{
    /// <summary>
    /// Constants shared between the Hudu C# client and the module's PowerShell cmdlets.
    /// </summary>
    public static class Consts
    {
        /// <summary>
        /// Default <c>ContextCache</c> key that Connect-Hudu registers the <c>HuduClient</c> under and
        /// that every other Hudu cmdlet reads it back from.
        /// </summary>
        public const string ClientCacheKey = "hudu";
    }
}
