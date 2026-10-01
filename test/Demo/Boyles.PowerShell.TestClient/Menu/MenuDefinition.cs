namespace Boyles.PowerShell.TestClient.Menu;

/// <summary>
/// The application's navigation menu, rendered by <c>MainMenu.razor</c>.
/// </summary>
/// <remarks>
/// <para>
/// Items are sorted at render time (see <see cref="MenuItem.SortedChildren"/>), so entries left at
/// <see cref="MenuItem.DefaultOrder"/> appear alphabetically regardless of the order they are listed
/// here; set <see cref="MenuItem.Order"/> only to pin something out of alphabetical order.
/// </para>
/// <para>
/// Structure: a top-level item with children becomes a dropdown. Within a dropdown, plain links are
/// rendered first, then a divider, then items that have children as flyout submenus split across columns.
/// </para>
/// </remarks>
public static class MenuDefinition
{
    /// <summary>
    /// The top-level menu items.
    /// </summary>
    public static IReadOnlyList<MenuItem> Items { get; } = new List<MenuItem>
    {
        Link("Home", "/", "ti ti-home", order: 0),

        Group("Hudu", "ti ti-package",
            Link("Connect", "/hudu/connect", "ti ti-plug-connected", order: 0),
            Link("Invoke (raw)", "/hudu/invoke", "ti ti-terminal-2", order: 1),

            Group("Activity Logs", "ti ti-activity",
                Link("Get Activity Logs", "/hudu/activity-logs/get-activity-logs")),

            Group("API Info", "ti ti-info-circle",
                Link("Get API Info", "/hudu/api-info/get-api-info")),

            Group("Articles", "ti ti-article",
                Link("Archive Article", "/hudu/articles/archive-article"),
                Link("Delete Article", "/hudu/articles/delete-article"),
                Link("Get Article", "/hudu/articles/get-article"),
                Link("Get Articles", "/hudu/articles/get-articles"),
                Link("Get Articles Page", "/hudu/articles/get-articles-page"),
                Link("New Article", "/hudu/articles/new-article"),
                Link("Unarchive Article", "/hudu/articles/unarchive-article"),
                Link("Update Article", "/hudu/articles/update-article")),

            Group("Asset Layouts", "ti ti-layout-list",
                Link("Add Asset Layout Fields", "/hudu/asset-layouts/add-asset-layout-fields"),
                Link("Get Asset Layout", "/hudu/asset-layouts/get-asset-layout"),
                Link("Get Asset Layouts", "/hudu/asset-layouts/get-asset-layouts"),
                Link("New Asset Layout", "/hudu/asset-layouts/new-asset-layout"),
                Link("Update Asset Layout", "/hudu/asset-layouts/update-asset-layout")),

            Group("Asset Passwords", "ti ti-key",
                Link("Archive Asset Password", "/hudu/asset-passwords/archive-asset-password"),
                Link("Delete Asset Password", "/hudu/asset-passwords/delete-asset-password"),
                Link("Get Asset Password", "/hudu/asset-passwords/get-asset-password"),
                Link("Get Asset Passwords", "/hudu/asset-passwords/get-asset-passwords"),
                Link("Get Asset Passwords Page", "/hudu/asset-passwords/get-asset-passwords-page"),
                Link("New Asset Password", "/hudu/asset-passwords/new-asset-password"),
                Link("Unarchive Asset Password", "/hudu/asset-passwords/unarchive-asset-password"),
                Link("Update Asset Password", "/hudu/asset-passwords/update-asset-password")),

            Group("Assets", "ti ti-package",
                Link("Archive Asset", "/hudu/assets/archive-asset"),
                Link("Delete Asset", "/hudu/assets/delete-asset"),
                Link("Get Asset", "/hudu/assets/get-asset"),
                Link("Get Assets", "/hudu/assets/get-assets"),
                Link("Get Assets For Company", "/hudu/assets/get-assets-for-company"),
                Link("New Asset", "/hudu/assets/new-asset"),
                Link("Unarchive Asset", "/hudu/assets/unarchive-asset"),
                Link("Update Asset", "/hudu/assets/update-asset")),

            Group("Cards", "ti ti-id-badge-2",
                Link("Get Card Lookup", "/hudu/cards/get-card-lookup")),

            Group("Companies", "ti ti-building",
                Link("Archive Company", "/hudu/companies/archive-company"),
                Link("Delete Company", "/hudu/companies/delete-company"),
                Link("Get Companies", "/hudu/companies/get-companies"),
                Link("Get Companies Page", "/hudu/companies/get-companies-page"),
                Link("Get Company", "/hudu/companies/get-company"),
                Link("New Company", "/hudu/companies/new-company"),
                Link("Unarchive Company", "/hudu/companies/unarchive-company"),
                Link("Update Company", "/hudu/companies/update-company")),

            Group("Expirations", "ti ti-calendar-due",
                Link("Delete Expiration", "/hudu/expirations/delete-expiration"),
                Link("Get Expirations", "/hudu/expirations/get-expirations"),
                Link("Update Expiration", "/hudu/expirations/update-expiration")),

            Group("Flags", "ti ti-flag",
                Link("Delete Flag", "/hudu/flags/delete-flag"),
                Link("Get Flag", "/hudu/flags/get-flag"),
                Link("Get Flags", "/hudu/flags/get-flags"),
                Link("New Flag", "/hudu/flags/new-flag"),
                Link("Update Flag", "/hudu/flags/update-flag")),

            Group("Flag Types", "ti ti-flag-3",
                Link("Delete Flag Type", "/hudu/flag-types/delete-flag-type"),
                Link("Get Flag Type", "/hudu/flag-types/get-flag-type"),
                Link("Get Flag Types", "/hudu/flag-types/get-flag-types"),
                Link("New Flag Type", "/hudu/flag-types/new-flag-type"),
                Link("Update Flag Type", "/hudu/flag-types/update-flag-type")),

            Group("Folders", "ti ti-folder",
                Link("Delete Folder", "/hudu/folders/delete-folder"),
                Link("Get Folder", "/hudu/folders/get-folder"),
                Link("Get Folders", "/hudu/folders/get-folders"),
                Link("New Folder", "/hudu/folders/new-folder"),
                Link("Update Folder", "/hudu/folders/update-folder")),

            Group("Groups", "ti ti-users-group",
                Link("Get Group", "/hudu/groups/get-group"),
                Link("Get Groups", "/hudu/groups/get-groups")),

            Group("IP Addresses", "ti ti-network",
                Link("Delete IP Address", "/hudu/ip-addresses/delete-ip-address"),
                Link("Get IP Address", "/hudu/ip-addresses/get-ip-address"),
                Link("Get IP Addresses", "/hudu/ip-addresses/get-ip-addresses"),
                Link("New IP Address", "/hudu/ip-addresses/new-ip-address"),
                Link("Update IP Address", "/hudu/ip-addresses/update-ip-address")),

            Group("Labels", "ti ti-tag",
                Link("Delete Label", "/hudu/labels/delete-label"),
                Link("Get Label", "/hudu/labels/get-label"),
                Link("Get Labels", "/hudu/labels/get-labels"),
                Link("New Label", "/hudu/labels/new-label"),
                Link("Update Label", "/hudu/labels/update-label")),

            Group("Label Types", "ti ti-tags",
                Link("Delete Label Type", "/hudu/label-types/delete-label-type"),
                Link("Get Label Type", "/hudu/label-types/get-label-type"),
                Link("Get Label Types", "/hudu/label-types/get-label-types"),
                Link("New Label Type", "/hudu/label-types/new-label-type"),
                Link("Update Label Type", "/hudu/label-types/update-label-type")))
    };

    /// <summary>
    /// Creates a navigable menu entry.
    /// </summary>
    private static MenuItem Link(string displayName, string url, string? icon = null, int order = MenuItem.DefaultOrder) =>
        new(order, displayName, url, icon);

    /// <summary>
    /// Creates a container entry (dropdown or submenu) with no URL of its own.
    /// </summary>
    private static MenuItem Group(string displayName, string icon, params MenuItem[] children) =>
        new(MenuItem.DefaultOrder, displayName, string.Empty, icon, children.ToList());
}
