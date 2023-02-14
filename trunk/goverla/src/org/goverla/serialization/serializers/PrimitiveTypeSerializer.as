package org.goverla.serialization.serializers
{
	import org.goverla.serialization.constants.SerializationConstants;
	import org.goverla.serialization.interfaces.ISerializer;
	import org.goverla.serialization.serializers.requirements.PrimitiveTypeRequirement;
	import org.goverla.serialization.utils.SerializationUtil;
	import org.goverla.utils.ReflectUtil;
	import org.goverla.interfaces.IRequirement;

	public class PrimitiveTypeSerializer implements ISerializer
	{
		public function toXML(object:Object, rootSerializer:ISerializer):XML
		{
			return SerializationUtil.createValueNode(
				ReflectUtil.getFullTypeName(object)
				, object.toString());
		}
		
		public function get serializerRequirement() : IRequirement {
			return new PrimitiveTypeRequirement();
		}
	}
}