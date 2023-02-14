package org.goverla.serialization.deserializers
{
	import org.goverla.serialization.deserializers.requirements.NodeToInstanceRequirement;
	import org.goverla.serialization.interfaces.IDeserializer;
	import org.goverla.serialization.serializers.requirements.ClassRequirement;
	import org.goverla.interfaces.IRequirement;
	
	

	public class NumberDeserializer implements IDeserializer
	{
		public function get deserializerRequirement():IRequirement
		{
			return new NodeToInstanceRequirement(new ClassRequirement(Number));
		}
		
		public function toObject(object:XML, rootDeserializer:IDeserializer):Object
		{
			var stringResult : String = String(object.children()[0]);
			stringResult = stringResult.replace(",", ".");
			return Number(stringResult);
		}
		
	}
}