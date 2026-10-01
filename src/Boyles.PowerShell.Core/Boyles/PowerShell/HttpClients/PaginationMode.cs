namespace Boyles.PowerShell.HttpClients
{
    /// <summary>
    /// How <c>HttpClientBase.GetAllPagesAsync</c> advances its position parameter between requests.
    /// </summary>
    public enum PaginationMode
    {
        /// <summary>
        /// The position is a count of records to skip: 0, then pageSize, then 2 × pageSize, and so on.
        /// </summary>
        Offset,

        /// <summary>
        /// The position is a page number: firstPage, then firstPage + 1, and so on.
        /// </summary>
        PageNumber
    }
}
