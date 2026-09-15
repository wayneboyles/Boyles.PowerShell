namespace Boyles.PowerShell.Context
{
    // ContextCache is a static, process-wide store, so every test below registers its own
    // GUID-derived key and removes it again in a finally block rather than calling Clear(),
    // which would also wipe out any clients registered by unrelated code running concurrently.
    public class ContextCacheTests
    {
        [Fact]
        public void Set_Get_ReturnsSameInstance()
        {
            var key = NewKey();
            var client = new FakeClient();

            try
            {
                ContextCache.Set(key, client);

                Assert.Same(client, ContextCache.Get(key));
            }
            finally
            {
                ContextCache.Remove(key);
            }
        }

        [Fact]
        public void Get_Generic_ReturnsTypedInstance()
        {
            var key = NewKey();
            var client = new FakeClient();

            try
            {
                ContextCache.Set(key, client);

                Assert.Same(client, ContextCache.Get<FakeClient>(key));
            }
            finally
            {
                ContextCache.Remove(key);
            }
        }

        [Fact]
        public void Get_UnknownKey_ThrowsKeyNotFoundException()
        {
            var key = NewKey();

            Assert.Throws<KeyNotFoundException>(() => ContextCache.Get(key));
        }

        [Fact]
        public void Get_Generic_WrongType_ThrowsInvalidOperationException()
        {
            var key = NewKey();

            try
            {
                ContextCache.Set(key, new FakeClient());

                Assert.Throws<InvalidOperationException>(() => ContextCache.Get<OtherClient>(key));
            }
            finally
            {
                ContextCache.Remove(key);
            }
        }

        [Fact]
        public void TryGet_UnknownKey_ReturnsFalse()
        {
            var key = NewKey();

            var found = ContextCache.TryGet<FakeClient>(key, out var client);

            Assert.False(found);
            Assert.Null(client);
        }

        [Fact]
        public void TryGet_WrongType_ReturnsFalse()
        {
            var key = NewKey();

            try
            {
                ContextCache.Set(key, new FakeClient());

                var found = ContextCache.TryGet<OtherClient>(key, out var client);

                Assert.False(found);
                Assert.Null(client);
            }
            finally
            {
                ContextCache.Remove(key);
            }
        }

        [Fact]
        public void TryGet_CorrectType_ReturnsTrueAndInstance()
        {
            var key = NewKey();
            var registered = new FakeClient();

            try
            {
                ContextCache.Set(key, registered);

                var found = ContextCache.TryGet<FakeClient>(key, out var client);

                Assert.True(found);
                Assert.Same(registered, client);
            }
            finally
            {
                ContextCache.Remove(key);
            }
        }

        [Fact]
        public void Contains_ReflectsRegistrationAndRemoval()
        {
            var key = NewKey();

            Assert.False(ContextCache.Contains(key));

            ContextCache.Set(key, new FakeClient());
            Assert.True(ContextCache.Contains(key));

            ContextCache.Remove(key);
            Assert.False(ContextCache.Contains(key));
        }

        [Fact]
        public void Keys_IncludesRegisteredKey()
        {
            var key = NewKey();

            try
            {
                ContextCache.Set(key, new FakeClient());

                Assert.Contains(key, ContextCache.Keys);
            }
            finally
            {
                ContextCache.Remove(key);
            }
        }

        [Fact]
        public void Lookups_AreCaseInsensitive()
        {
            var key = NewKey();
            var client = new FakeClient();

            try
            {
                ContextCache.Set(key.ToUpperInvariant(), client);

                Assert.True(ContextCache.Contains(key.ToLowerInvariant()));
                Assert.Same(client, ContextCache.Get(key.ToLowerInvariant()));
            }
            finally
            {
                ContextCache.Remove(key);
            }
        }

        [Theory]
        [InlineData(null)]
        [InlineData("")]
        [InlineData("   ")]
        public void Set_NullOrWhitespaceKey_ThrowsArgumentException(string? key)
        {
            Assert.Throws<ArgumentException>(() => ContextCache.Set(key!, new FakeClient()));
        }

        [Fact]
        public void Set_NullClient_ThrowsArgumentNullException()
        {
            var key = NewKey();

            Assert.Throws<ArgumentNullException>(() => ContextCache.Set(key, null!));
        }

        [Fact]
        public void Set_ReplacingKey_DisposesPreviousDisposableClient()
        {
            var key = NewKey();
            var original = new DisposableClient();
            var replacement = new DisposableClient();

            try
            {
                ContextCache.Set(key, original);
                ContextCache.Set(key, replacement);

                Assert.True(original.Disposed);
                Assert.False(replacement.Disposed);
                Assert.Same(replacement, ContextCache.Get(key));
            }
            finally
            {
                ContextCache.Remove(key);
            }
        }

        [Fact]
        public void Set_ReRegisteringSameInstance_DoesNotDisposeIt()
        {
            var key = NewKey();
            var client = new DisposableClient();

            try
            {
                ContextCache.Set(key, client);
                ContextCache.Set(key, client);

                Assert.False(client.Disposed);
            }
            finally
            {
                ContextCache.Remove(key);
            }
        }

        [Fact]
        public void Remove_DisposesDisposableClientAndReturnsTrue()
        {
            var key = NewKey();
            var client = new DisposableClient();
            ContextCache.Set(key, client);

            var removed = ContextCache.Remove(key);

            Assert.True(removed);
            Assert.True(client.Disposed);
            Assert.False(ContextCache.Contains(key));
        }

        [Fact]
        public void Remove_UnknownKey_ReturnsFalse()
        {
            var key = NewKey();

            Assert.False(ContextCache.Remove(key));
        }

        [Fact]
        public void Clear_RemovesAndDisposesRegisteredClients()
        {
            var keyA = NewKey();
            var keyB = NewKey();
            var clientA = new DisposableClient();
            var clientB = new DisposableClient();

            ContextCache.Set(keyA, clientA);
            ContextCache.Set(keyB, clientB);

            ContextCache.Clear();

            Assert.True(clientA.Disposed);
            Assert.True(clientB.Disposed);
            Assert.False(ContextCache.Contains(keyA));
            Assert.False(ContextCache.Contains(keyB));
        }

        private static string NewKey() => Guid.NewGuid().ToString("N");

        private sealed class FakeClient
        {
        }

        private sealed class OtherClient
        {
        }

        private sealed class DisposableClient : IDisposable
        {
            public bool Disposed { get; private set; }

            public void Dispose() => Disposed = true;
        }
    }
}
