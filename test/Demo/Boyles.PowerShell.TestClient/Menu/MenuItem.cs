namespace Boyles.PowerShell.TestClient.Menu;

public sealed class MenuItem
{
    public const int DefaultOrder = 1000;

    public int Order { get; set; } = DefaultOrder;

    public string DisplayName { get; set; } = string.Empty;

    public string Url { get; set; } = string.Empty;
    
    public string? Icon { get; set; }

    public List<MenuItem> Children { get; set; } = new();
    
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