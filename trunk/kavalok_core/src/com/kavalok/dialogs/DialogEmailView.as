package com.kavalok.dialogs
{
	import com.kavalok.Global;
	
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import com.kavalok.dialogs.Dialogs;
	import flash.events.MouseEvent;
	import com.kavalok.services.CharService;
	
	import com.kavalok.events.EventSender;
	
	public class DialogEmailView extends DialogViewBase
	{
		public var okButton:SimpleButton;
		public var emailField:TextField;
		
		private var _yes:EventSender = new EventSender();
		private var _no:EventSender = new EventSender();
		
		public function DialogEmailView(text:String = null, modal:Boolean = true)
		{
			super(new DialogEmail(), text, modal);
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
		}
		
		public function get yes():EventSender
		{
			return _yes;
		}
		
		public function get no():EventSender
		{
			return _no;
		}
		
		private function onOkClick(event:MouseEvent):void
		{
			
			if ((emailField.text.indexOf("@") != -1) && emailField.text.length > 10)
			{
				hide();
				new CharService().setEmail(Global.charManager.userId, emailField.text);
				Global.charManager.email = emailField.text;
				yes.sendEvent();
			}
			else
			{
				Dialogs.showOkDialog("Invalid E-mail address");
			}
		
		}
	
	}
}