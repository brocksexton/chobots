package org.goverla.serialization.deserializers
{
	import org.goverla.serialization.deserializers.requirements.ClassNodeRequirement;
	import org.goverla.serialization.interfaces.IDeserializer;
	import org.goverla.utils.ReflectUtil;
	import org.goverla.interfaces.IRequirement;
	
	

	public class ClassDeserializer implements IDeserializer
	{
		public function get deserializerRequirement():IRequirement
		{
			return new ClassNodeRequirement();
		}
		
		public function toObject(object:XML, rootDeserializer:IDeserializer):Object
		{
			return ReflectUtil.getTypeByName(String(object.children()[0]));
		}
		
	}
}