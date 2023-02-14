package org.goverla.serialization.serializers
{
	import org.goverla.serialization.constants.SerializationConstants;
	import org.goverla.serialization.interfaces.ISerializer;
	import org.goverla.serialization.serializers.requirements.ClassRequirement;
	import org.goverla.serialization.utils.SerializationUtil;
	import org.goverla.utils.Objects;
	import org.goverla.utils.ReflectUtil;
	import org.goverla.interfaces.IRequirement;
	
	public class ArraySerializer extends BaseCollectionSerializer
	{
		override public function get serializerRequirement():IRequirement
		{
			return new ClassRequirement(Array);
		}
		
		override protected function getLength(object:Object):int {
			return Objects.castToArray(object).length;
		}
		
		override protected function getChild(object : Object, index:int):Object {
			return Objects.castToArray(object)[index];
		}
		
	}
}