package com.kavalok.admin
{
	import com.kavalok.dto.StateInfoTO;
	import com.kavalok.localization.Localiztion;
	
	import mx.core.Application;
	

	public class KavalokAdminBase extends Application
	{
		initialize();
		private static function initialize() : void
		{
			StateInfoTO.initialize();
 			Localiztion.urlFormat = "resources/localization/{0}.{1}.xml";
		}
		
		public function KavalokAdminBase()
		{
		}
		
	}
}