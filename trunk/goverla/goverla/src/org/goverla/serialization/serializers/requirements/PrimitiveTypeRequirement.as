package org.goverla.serialization.serializers.requirements
{
	import org.goverla.interfaces.IRequirement;
	import org.goverla.utils.Objects;

	public class PrimitiveTypeRequirement implements IRequirement
	{
		public function meet(object:Object):Boolean
		{
			return Objects.isPrimitive(object);
		}
		
	}
}