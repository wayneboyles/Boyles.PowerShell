namespace Boyles.PowerShell.Attributes
{
    public class QueryPropertyAttributeTests
    {
        [Fact]
        public void Constructor_SetsName()
        {
            var attribute = new QueryPropertyAttribute("company_id");

            Assert.Equal("company_id", attribute.Name);
        }

        [Theory]
        [InlineData(null)]
        [InlineData("")]
        [InlineData("   ")]
        public void Constructor_NullOrWhitespaceName_ThrowsArgumentException(string? name)
        {
            Assert.Throws<ArgumentException>(() => new QueryPropertyAttribute(name!));
        }

        [Fact]
        public void AttributeUsage_TargetsParameterOnlyAndIsNotInheritedOrMultiple()
        {
            var usage = GetUsage<QueryPropertyAttribute>();

            Assert.Equal(AttributeTargets.Parameter, usage.ValidOn);
            Assert.False(usage.AllowMultiple);
            Assert.False(usage.Inherited);
        }

        private static AttributeUsageAttribute GetUsage<T>()
            where T : Attribute
        {
            return (AttributeUsageAttribute)Attribute.GetCustomAttribute(typeof(T), typeof(AttributeUsageAttribute))!;
        }
    }
}
