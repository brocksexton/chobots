package com.kavalok.admin.config
{
	import com.kavalok.admin.config.data.ConfigData;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.CheckBox;
	import mx.controls.TextInput;

	public class ConfigBase extends VBox
	{
		public var registrationCheckBox : CheckBox;
		public var guestCheckBox : CheckBox;
		public var adyenCheckBox : CheckBox;
		public var spamMessagesLimitInput : TextInput;
		public var serverLoadInput : TextInput;
		public var gameVersionInput : TextInput;
		public var savedDataInput : TextInput;
		
		[Bindable]
		public var dataProvider : ConfigData = new ConfigData();
		
		[Bindable]
		protected var changed : Boolean;

		
		public function ConfigBase()
		{
			super();
			
		}

		
		public function onSaveClick(event : MouseEvent) : void
		{
			dataProvider.registrationEnabled = registrationCheckBox.selected;
			//dataProvider.guestEnabled = guestCheckBox.selected;
			//dataProvider.adyenEnabled = adyenCheckBox.selected;
			dataProvider.spamMessagesLimit = int(spamMessagesLimitInput.text);
			dataProvider.serverLimit = int(serverLoadInput.text);
			dataProvider.gameVersion = 1;
			dataProvider.savedData = savedDataInput.text;
			dataProvider.update();
		//	partyOn = partyCheckBox.selected;
			changed = true;
		}
		
	}
}