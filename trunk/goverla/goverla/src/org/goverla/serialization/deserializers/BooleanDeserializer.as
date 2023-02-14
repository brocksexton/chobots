package org.goverla.serialization.deserializers
{
	import org.goverla.serialization.deserializers.requirements.NodeToInstanceRequirement;
	import org.goverla.serialization.interfaces.IDeserializer;
	import org.goverla.serialization.serializers.requirements.ClassRequirement;
	import org.goverla.interfaces.IRequirement;
	
	

	public class BooleanDeserializer implements IDeserializer
	{
		public function get deserializerRequirement():IRequirement
		{
			return new NodeToInstanceRequirement(new ClassRequirement(Boolean));
		}
		
		public function toObject(object:XML, rootDeserializer:IDeserializer):Object
		{
			return String(object.children()[0]) == String(true);
		}
		
	}
}