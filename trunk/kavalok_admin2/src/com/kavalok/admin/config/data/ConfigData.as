package com.kavalok.admin.config.data
{
	import com.kavalok.services.AdminService;
	
	public class ConfigData
	{
		[Bindable]
		public var registrationEnabled : Boolean;
		[Bindable]
		public var guestEnabled : Boolean;
		[Bindable]
		public var adyenEnabled : Boolean;
		[Bindable]
		public var spamMessagesLimit : int;
		[Bindable]
		public var serverLimit : int;
		
		
		public function ConfigData()
		{
			new AdminService(onResult).getConfig();
		}
		
		public function update() : void
		{
			new AdminService().saveConfig(registrationEnabled, guestEnabled, adyenEnabled, spamMessagesLimit, serverLimit);
		}
		
		private function onResult(result:Object) : void
		{
			registrationEnabled = result.registrationEnabled;
			guestEnabled = result.guestEnabled;
			adyenEnabled = result.adyenEnabled;
			spamMessagesLimit = result.spamMessagesLimit;
			serverLimit = result.serverLimit;
		}

	}
}