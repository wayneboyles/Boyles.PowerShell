namespace Boyles.PowerShell.Attributes
{
    public class BodyPropertyAttributeTests
    {
        [Fact]
        public void Constructor_SetsName()
        {
            var attribute = new BodyPropertyAttribute("passwordable_type");

            Assert.Equal("passwordable_type", attribute.Name);
        }

        [Theory]
        [InlineData(null)]
        [InlineData("")]
        [InlineData("   ")]
        public void Constructor_NullOrWhitespaceName_ThrowsArgumentException(string? name)
        {
            Assert.Throws<ArgumentException>(() => new BodyPropertyAttribute(name!));
        }

        [Fact]
        public void AttributeUsage_TargetsParameterOnlyAndIsNotInheritedOrMultiple()
        {
            var usage = GetUsage<BodyPropertyAttribute>();

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
