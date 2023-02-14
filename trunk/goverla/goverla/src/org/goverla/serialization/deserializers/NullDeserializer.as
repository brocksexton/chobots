package org.goverla.serialization.deserializers
{
	import org.goverla.serialization.deserializers.requirements.NullNodeRequirement;
	import org.goverla.serialization.interfaces.IDeserializer;
	import org.goverla.interfaces.IRequirement;

	public class NullDeserializer implements IDeserializer
	{
		public function get deserializerRequirement():IRequirement
		{
			return new NullNodeRequirement();
		}
		
		public function toObject(object:XML, rootDeserializer:IDeserializer):Object
		{
			return null;
		}
		
	}
}