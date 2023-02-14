package com.kavalok.localization.interfaces
{
	import com.kavalok.localization.ResourceBundle;
	
	public interface IResourceBundleFactory
	{
		function createBundle(id : String) : ResourceBundle;
	}
}