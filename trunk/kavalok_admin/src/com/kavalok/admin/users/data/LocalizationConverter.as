package com.kavalok.admin.users.data
{
	import com.kavalok.localization.ResourceBundle;
	
	import org.goverla.interfaces.IConverter;;

	public class LocalizationConverter implements IConverter
	{
		private var _bundle : ResourceBundle;
		
		public function LocalizationConverter(bundle : ResourceBundle)
		{
			_bundle = bundle;
		}

		public function convert(source:Object):Object
		{
			return _bundle.messages[source] || source;
		}
		
	}
}