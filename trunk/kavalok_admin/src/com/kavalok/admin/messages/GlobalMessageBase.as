package com.kavalok.admin.messages
{
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LogService;
	import com.kavalok.services.MessageService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.CheckBox;
	import mx.controls.TextArea;

	public class GlobalMessageBase extends VBox
	{
		[Bindable]
		public var messageTextArea : TextArea;
		public var localeCheckBoxes : Object;
		
		public function GlobalMessageBase()
		{
			super();
		}
		
		protected function onSendClick(event : MouseEvent) : void
		{
			var locales : Array = [];
			for each(var checkBox : CheckBox in localeCheckBoxes)
			{
				if(checkBox.selected)
				{
					locales.push(checkBox.label);
				}
			}
			new AdminService().sendGlobalMessageToChobotsWorld(messageTextArea.text, locales);
			new LogService().adminLog("Sent global message saying " + messageTextArea.text, 1, "global message");
			messageTextArea.text = "";
		}
		
	}
}