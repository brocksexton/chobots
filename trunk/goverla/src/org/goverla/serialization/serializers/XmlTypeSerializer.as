package org.goverla.serialization.serializers
{
	import org.goverla.serialization.interfaces.ISerializer;
	import org.goverla.serialization.serializers.requirements.ClassRequirement;
	import org.goverla.serialization.utils.SerializationUtil;
	import org.goverla.utils.Objects;
	import org.goverla.utils.ReflectUtil;
	import org.goverla.interfaces.IRequirement;
	
	

	public class XmlTypeSerializer implements ISerializer
	{
		public function toXML(object:Object, rootSerializer:ISerializer):XML
		{
			var result : XML = SerializationUtil.createEmptyNode(ReflectUtil.getFullTypeName(object));
			result.appendChild(XML(object));
			return result;
		}
		
		public function get serializerRequirement():IRequirement
		{
			return new ClassRequirement(XML);
		}
		
	}
}