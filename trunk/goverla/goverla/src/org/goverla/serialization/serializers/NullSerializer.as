package org.goverla.serialization.serializers
{
	import org.goverla.serialization.constants.SerializationConstants;
	import org.goverla.serialization.interfaces.ISerializer;
	import org.goverla.serialization.utils.SerializationUtil;
	import org.goverla.utils.comparing.EqualsRequirement;
	import org.goverla.interfaces.IRequirement;

	public class NullSerializer implements ISerializer
	{
		public function toXML(object:Object, rootSerializer:ISerializer):XML
		{
			return SerializationUtil.createEmptyNode(SerializationConstants.NULL_NODE_TYPE);
		}
		
		public function get serializerRequirement():IRequirement
		{
			return new EqualsRequirement(null);
		}
		
	}
}