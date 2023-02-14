package com.kavalok.admin.mail
{
	import com.kavalok.services.AdminService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.CheckBox;
	import mx.controls.TextArea;
	import mx.controls.TextInput;

	public class MailBase extends VBox
	{
		
		public var subjTextInput : TextInput;
		public var bodyTextArea : TextArea;
		public var localesCheckBoxes : Object;
		
		[Bindable]
		protected var sendEnabled : Boolean = true;
		
		public function MailBase()
		{
			super();
		}
		
		protected function onSendClick(event : MouseEvent) : void
		{
			var locales : Array = [];
			for each(var checkBox : CheckBox in localesCheckBoxes)
			{
				locales.push(checkBox.data);
			}
			new AdminService(onSendMail).sendMail(subjTextInput.text, bodyTextArea.text, locales);
			sendEnabled = false;
		}
		
		private function onSendMail(result : Object) : void
		{
			sendEnabled = true;
		}
		
	}
}