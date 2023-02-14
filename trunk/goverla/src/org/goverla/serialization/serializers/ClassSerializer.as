package org.goverla.serialization.serializers
{
	import org.goverla.serialization.constants.SerializationConstants;
	import org.goverla.serialization.interfaces.ISerializer;
	import org.goverla.serialization.serializers.requirements.ClassRequirement;
	import org.goverla.serialization.utils.SerializationUtil;
	import org.goverla.utils.ReflectUtil;
	import org.goverla.interfaces.IRequirement;
	
	public class ClassSerializer implements ISerializer
	{
		public function toXML(object:Object, rootSerializer:ISerializer):XML {
			return SerializationUtil.createValueNode(SerializationConstants.CLASS_NODE_TYPE
				, ReflectUtil.getFullTypeName(object));
		}
		
		public function get serializerRequirement():IRequirement {
			return new ClassRequirement(Class);
		}
		
	}
}