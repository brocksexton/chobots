package org.goverla.serialization.interfaces
{
	import org.goverla.interfaces.IRequirement;
	
	public interface IDeserializer
	{

		function get deserializerRequirement() : IRequirement;
		function toObject(object : XML, rootDeserializer : IDeserializer) : Object;
		
	}
}