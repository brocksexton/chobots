package org.goverla.serialization.deserializers
{
	import org.goverla.serialization.deserializers.requirements.NodeToInstanceRequirement;
	import org.goverla.serialization.interfaces.IDeserializer;
	import org.goverla.serialization.serializers.requirements.ClassRequirement;
	import org.goverla.interfaces.IRequirement;
	import mx.utils.StringUtil;
	import org.goverla.utils.Strings;
	
	

	public class StringDeserializer implements IDeserializer
	{
		public function get deserializerRequirement():IRequirement
		{
			return new NodeToInstanceRequirement(new ClassRequirement(String));
		}
		
		public function toObject(object:XML, rootDeserializer:IDeserializer):Object
		{
			return String(object.children()[0]);
/*			var string : String = String(object.children()[0]);
			string = StringUtil.trim(string);
			return string.substring(1, string.length - 1);*/
		}
		
	}
}