package org.goverla.serialization.deserializers
{
	import org.goverla.serialization.deserializers.requirements.NodeToInstanceRequirement;
	import org.goverla.serialization.interfaces.IDeserializer;
	import org.goverla.serialization.serializers.requirements.ClassRequirement;
	import org.goverla.interfaces.IRequirement;
	
	

	public class XMLTypeDeserializer implements IDeserializer
	{
		public function get deserializerRequirement():IRequirement
		{
			return new NodeToInstanceRequirement(new ClassRequirement(XML));
		}
		
		public function toObject(object:XML, rootDeserializer:IDeserializer):Object
		{
			return object.children()[0];
		}
		
	}
}