package org.goverla.interfaces
{

	public interface IPropertiesInvalidable
	{
		function invalidateProperties() : void;

		function commitProperties() : void;
	}
}