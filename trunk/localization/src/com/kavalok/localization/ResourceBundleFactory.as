package com.kavalok.localization
{
	import com.kavalok.localization.interfaces.IResourceBundleFactory;

	public class ResourceBundleFactory implements IResourceBundleFactory
	{
		public function ResourceBundleFactory()
		{
		}

		public function createBundle(id : String):ResourceBundle
		{
			return new ResourceBundle(id);
		}
		
	}
}