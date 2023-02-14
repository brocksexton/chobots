package com.kavalok.admin.config.data
{
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LogService;
	
	public class ConfigData
	{
		[Bindable]
		public var registrationEnabled : Boolean;
		[Bindable]
		public var guestEnabled : Boolean = false;
		[Bindable]
		public var adyenEnabled : Boolean = false;
		[Bindable]
		public var spamMessagesLimit : int;
		[Bindable]
		public var serverLimit : int;
		[Bindable]
		public var gameVersion : int;
		[Bindable]
		public var savedData:String;// = "off_loc3";
		
		
		
		public function ConfigData()
		{
			new AdminService(onResult).getConfig();
		}
		
		public function update() : void
		{
			new AdminService().saveConfig(registrationEnabled, guestEnabled, adyenEnabled, spamMessagesLimit, serverLimit, gameVersion, savedData);
			new LogService().adminLog("Saved config [" + registrationEnabled + "," + serverLimit + "," + savedData + "]", 1, "config");
		}
		
		private function onResult(result:Object) : void
		{
			registrationEnabled = result.registrationEnabled;
			guestEnabled = result.guestEnabled;
			adyenEnabled = result.adyenEnabled;
			spamMessagesLimit = result.spamMessagesLimit;
			serverLimit = result.serverLimit;
			gameVersion = result.gameVersion;
			savedData = result.savedData;
		}

		
	}
}