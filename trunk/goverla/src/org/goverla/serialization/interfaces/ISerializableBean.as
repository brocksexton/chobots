package org.goverla.serialization.interfaces
{
	import org.goverla.collections.ArrayList;
	
	public interface ISerializableBean
	{
		function get ignoredProperties() : ArrayList;
		
	}
}