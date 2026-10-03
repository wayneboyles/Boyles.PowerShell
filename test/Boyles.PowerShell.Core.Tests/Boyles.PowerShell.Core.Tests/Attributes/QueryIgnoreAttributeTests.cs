namespace Boyles.PowerShell.Attributes
{
    public class QueryIgnoreAttributeTests
    {
        [Fact]
        public void Constructor_CreatesInstance()
        {
            var attribute = new QueryIgnoreAttribute();

            Assert.NotNull(attribute);
        }

        [Fact]
        public void AttributeUsage_TargetsParameterOnlyAndIsNotInheritedOrMultiple()
        {
            var usage = GetUsage<QueryIgnoreAttribute>();

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
