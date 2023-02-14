package org.goverla.serialization.interfaces
{
	import org.goverla.interfaces.IRequirement;
	
	public interface ISerializer
	{
		function get serializerRequirement() : IRequirement;
		function toXML(object : Object, rootSerializer : ISerializer) : XML;
	}
}