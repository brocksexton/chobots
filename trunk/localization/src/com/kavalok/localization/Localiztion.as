package com.kavalok.localization
{
	import com.kavalok.utils.Strings;
	
	// Deprecated. Use Flex 3 localization
	public class Localiztion
	{
		public static var urlFormat : String = "{0}.{1}.xml";

		private static var bundles : Object = new Object();
		
//		private static var _bundlesFactory : IResourceBundleFactory;
		private static var _locale : String;
		
	
		public static function get locale():String
		{
			return _locale;
		}

		public static function set locale(value:String):void
		{
			if(locale != value)
			{
				_locale = value;
				for each(var bundle : ResourceBundle in bundles)
				{
					bundle.locale = value;
				}
			}
		}

		public static function getBundle(id : String) : ResourceBundle
		{
			if(bundles[id] != null)
			{
				return bundles[id];
			}
			else
			{
				var bundle : ResourceBundle = new ResourceBundle(id);
				bundles[id] = bundle;
				bundle.locale = locale;
				return bundle;
			}
			
		}
		public static function getUrl(bundleId : String, locale : String) : String
		{
			return Strings.substitute(urlFormat, bundleId, locale);
		}
		
	}
}