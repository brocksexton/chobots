package org.goverla.serialization.serializers
{
	import org.goverla.serialization.interfaces.ISerializer;
	import org.goverla.serialization.serializers.requirements.ClassRequirement;
	import org.goverla.serialization.utils.SerializationUtil;
	import org.goverla.utils.Objects;
	import org.goverla.utils.ReflectUtil;
	import org.goverla.utils.Strings;
	import org.goverla.interfaces.IRequirement;
	import org.goverla.serialization.serializers.requirements.TypeOfRequirement;

	public class StringSerializer implements ISerializer
	{
		public function toXML(object:Object, rootSerializer:ISerializer):XML
		{
			var string : String = Objects.castToString(object);
			return SerializationUtil.createValueNode(
				ReflectUtil.getFullTypeName(object)
				, Strings.escapeSpecialCharacters(string));
		}
		
		public function get serializerRequirement():IRequirement
		{
			return new TypeOfRequirement(Objects.TYPE_STRING);
		}
		
	}
}