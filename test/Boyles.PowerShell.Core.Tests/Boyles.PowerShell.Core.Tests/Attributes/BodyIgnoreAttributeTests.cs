namespace Boyles.PowerShell.Attributes
{
    public class BodyIgnoreAttributeTests
    {
        [Fact]
        public void Constructor_CreatesInstance()
        {
            var attribute = new BodyIgnoreAttribute();

            Assert.NotNull(attribute);
        }

        [Fact]
        public void AttributeUsage_TargetsParameterOnlyAndIsNotInheritedOrMultiple()
        {
            var usage = GetUsage<BodyIgnoreAttribute>();

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
