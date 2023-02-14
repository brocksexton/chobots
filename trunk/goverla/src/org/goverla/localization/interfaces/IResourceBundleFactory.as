package org.goverla.localization.interfaces
{
	import org.goverla.localization.ResourceBundle;
	
	public interface IResourceBundleFactory
	{
		function createBundle(id : String) : ResourceBundle;
	}
}