using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services;

/// <summary>
/// Partial class containing Hudu Folder-related API operations.
/// </summary>
public partial class HuduClient
{
    public HuduFolder GetFolder(int id) => Sync(GetFolderAsync(id));

    public async Task<HuduFolder> GetFolderAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/folders/{1}", ApiRoot, id);
        return await GetAsync<HuduFolder>(path, itemsProperty: "folders", ct: cancellationToken);
    }

    public List<HuduFolder> GetFolders(Dictionary<string, string>? query = null) => Sync(GetFoldersAsync(query));

    public async Task<List<HuduFolder>> GetFoldersAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/folders", ApiRoot);
        return await GetAllPagesAsync<HuduFolder>(path, query, itemsProperty: "folders", ct: cancellationToken);
    }

    public HuduFolder NewFolder(object body) => Sync(NewFolderAsync(body));
    
    public async Task<HuduFolder> NewFolderAsync(object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/folders", ApiRoot);

        var wrapper = new
        {
            folder = body
        };

        return await PostAsync<HuduFolder>(path, wrapper, itemsProperty: "folder", ct: cancellationToken);
    }

    public HuduFolder UpdateFolder(int id, object body) => Sync(UpdateFolderAsync(id, body));

    public async Task<HuduFolder> UpdateFolderAsync(int id, object body, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/folders/{1}", ApiRoot, id);
        
        var wrapper = new
        {
            folder = body
        };
        
        return await PutAsync<HuduFolder>(path, wrapper, itemsProperty: "folder", ct: cancellationToken);
    }

    public void DeleteFolder(int id) => Sync(DeleteFolderAsync(id));

    public async Task DeleteFolderAsync(int id, CancellationToken cancellationToken = default)
    {
        var path = string.Format(CultureInfo.InvariantCulture, "{0}/folders/{1}", ApiRoot, id);
        _ = await DeleteAsync<HuduFolder>(path, itemsProperty: "folder", ct: cancellationToken);
    }
}
