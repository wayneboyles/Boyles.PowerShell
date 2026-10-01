using System.Collections.Concurrent;

namespace Boyles.PowerShell.Context
{
    /// <summary>
    /// Process-wide, thread-safe store of connected service clients keyed by a caller-chosen
    /// string (e.g. "Hudu", "Hudu-Prod"). A service module's Connect-* cmdlet builds its client
    /// (e.g. HuduClient) and registers it here under a key; every other cmdlet in that module
    /// looks the client back up by the same key instead of requiring it to be passed to every
    /// call, the same way Connect-AzAccount leaves behind a context later Az cmdlets read
    /// implicitly.
    /// </summary>
    public static class ContextCache
    {
        /// <summary>
        /// Key used when a caller registers or looks up a client without specifying one
        /// explicitly - the common case for scripts that only ever talk to a single instance
        /// of a given service.
        /// </summary>
        public const string DefaultKey = "Default";

        private static readonly ConcurrentDictionary<string, object> _clients =
            new(StringComparer.OrdinalIgnoreCase);

        /// <summary>
        /// Registers a client under the given key. Registering a second client under a key that
        /// is already in use replaces the previous one, disposing it first if it implements
        /// IDisposable, so re-running Connect-* for the same key does not leak the old client's
        /// HttpClient/socket resources.
        /// </summary>
        /// <param name="key">Unique, case-insensitive name to register the client under.</param>
        /// <param name="client">The client instance to store, e.g. a HuduClient.</param>
        /// <exception cref="ArgumentException"><paramref name="key"/> is null, empty, or whitespace.</exception>
        /// <exception cref="ArgumentNullException"><paramref name="client"/> is null.</exception>
        public static void Set(string key, object client)
        {
            if (string.IsNullOrWhiteSpace(key))
            {
                throw new ArgumentException("key is required", nameof(key));
            }

            if (client is null)
            {
                throw new ArgumentNullException(nameof(client));
            }

            _clients.AddOrUpdate(key, client, (_, existing) =>
            {
                if (!ReferenceEquals(existing, client) && existing is IDisposable disposable)
                {
                    disposable.Dispose();
                }

                return client;
            });
        }

        /// <summary>
        /// Retrieves the client registered under the given key.
        /// </summary>
        /// <param name="key">Case-insensitive name the client was registered under.</param>
        /// <returns>The registered client.</returns>
        /// <exception cref="KeyNotFoundException">No client is registered under <paramref name="key"/>.</exception>
        public static object Get(string key)
        {
            if (!_clients.TryGetValue(key, out var client))
            {
                throw new KeyNotFoundException($"No client is registered under key '{key}'. Call the service's Connect-* cmdlet first.");
            }

            return client;
        }

        /// <summary>
        /// Retrieves the client registered under the given key, cast to <typeparamref name="T"/>.
        /// </summary>
        /// <typeparam name="T">The expected client type, e.g. HuduClient.</typeparam>
        /// <param name="key">Case-insensitive name the client was registered under.</param>
        /// <returns>The registered client as a <typeparamref name="T"/>.</returns>
        /// <exception cref="KeyNotFoundException">No client is registered under <paramref name="key"/>.</exception>
        /// <exception cref="InvalidOperationException">
        /// A client is registered under <paramref name="key"/> but is not a <typeparamref name="T"/>.
        /// </exception>
        public static T Get<T>(string key) where T : class
        {
            var client = Get(key);

            if (client is not T typed)
            {
                throw new InvalidOperationException(
                    $"The client registered under key '{key}' is a {client.GetType().FullName}, not {typeof(T).FullName}.");
            }

            return typed;
        }

        /// <summary>
        /// Attempts to retrieve the client registered under the given key. Returns false, without
        /// throwing, when no client is registered under that key or it is not a <typeparamref name="T"/>.
        /// </summary>
        /// <typeparam name="T">The expected client type, e.g. HuduClient.</typeparam>
        /// <param name="key">Case-insensitive name the client was registered under.</param>
        /// <param name="client">The registered client when found; otherwise null.</param>
        /// <returns>True if a <typeparamref name="T"/> is registered under <paramref name="key"/>.</returns>
        public static bool TryGet<T>(string key, out T? client) where T : class
        {
            if (_clients.TryGetValue(key, out var found) && found is T typed)
            {
                client = typed;
                return true;
            }

            client = null;
            return false;
        }

        /// <summary>
        /// Returns true when a client is currently registered under the given key.
        /// </summary>
        /// <param name="key">Case-insensitive name to check.</param>
        /// <returns>True if a client is registered under <paramref name="key"/>.</returns>
        public static bool Contains(string key) => _clients.ContainsKey(key);

        /// <summary>
        /// The keys of every client currently registered.
        /// </summary>
        public static IReadOnlyCollection<string> Keys => _clients.Keys.ToArray();

        /// <summary>
        /// Removes the client registered under the given key, disposing it first if it implements
        /// IDisposable. Returns false, without throwing, when no client was registered under that key.
        /// </summary>
        /// <param name="key">Case-insensitive name of the client to remove.</param>
        /// <returns>True if a client was removed; otherwise false.</returns>
        public static bool Remove(string key)
        {
            if (_clients.TryRemove(key, out var client))
            {
                (client as IDisposable)?.Dispose();
                return true;
            }

            return false;
        }

        /// <summary>
        /// Removes and disposes every registered client.
        /// </summary>
        public static void Clear()
        {
            foreach (var key in _clients.Keys.ToArray())
            {
                Remove(key);
            }
        }
    }
}
