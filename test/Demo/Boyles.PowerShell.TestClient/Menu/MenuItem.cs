namespace Boyles.PowerShell.TestClient.Menu;

public sealed class MenuItem
{
    public const int DefaultOrder = 1000;

    public int Order { get; set; } = DefaultOrder;

    public string DisplayName { get; set; } = string.Empty;

    public string Url { get; set; } = string.Empty;
    
    public string? Icon { get; set; }

    public List<MenuItem> Children { get; set; } = new();

    /// <summary>
    /// True when this item is a container (dropdown or submenu) rather than a link.
    /// </summary>
    public bool HasChildren => Children.Count > 0;

    /// <summary>
    /// Children in display order: by <see cref="Order"/>, then alphabetically by
    /// <see cref="DisplayName"/>, so items left at <see cref="DefaultOrder"/> sort alphabetically.
    /// </summary>
    public IEnumerable<MenuItem> SortedChildren => Sort(Children);

    /// <summary>
    /// Sorts menu items into display order; see <see cref="SortedChildren"/>.
    /// </summary>
    public static IEnumerable<MenuItem> Sort(IEnumerable<MenuItem> items) =>
        items.OrderBy(i => i.Order).ThenBy(i => i.DisplayName, StringComparer.OrdinalIgnoreCase);

    public MenuItem()
    {
        
    }

    public MenuItem(int order, string displayName, string url, string? icon = null)
    {
        Order = order;
        DisplayName = displayName;
        Url = url;
        Icon = icon;
        Children = new();
    }

    public MenuItem(int order, string displayName, string url, string? icon = null, List<MenuItem>? children = null)
    {
        Order = order;
        DisplayName = displayName;
        Url = url;
        Icon = icon;
        Children = children ?? new List<MenuItem>();
    }
    
}