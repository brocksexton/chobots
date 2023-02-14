package com.kavalok.dialogs
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.kavalok.Global;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import com.kavalok.services.AdminService;
	import com.kavalok.utils.Strings;
	
	import com.kavalok.events.EventSender;
	
	public class DialogLongTextView extends DialogViewBase
	{
		public var okButton:SimpleButton;
		public var passTxt:TextField;
		public var passConfTxt:TextField;
		
		static private const PASSW_CORRECT:String = 'correctPassword';
		private var _ok:EventSender = new EventSender();
		
		public function DialogLongTextView(text:String = null, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = false)
		{
			super(content || new LongTextMessage(), text, modal);
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			okButton.visible = okVisible;
		}
		
		public function get ok():EventSender
		{
			return _ok;
		}
		
		protected function onOkClick(event:MouseEvent):void
		{
			if(passTxt.text.length < 6)
			{

			Dialogs.showOkDialog("Come on, you can do better than that! Enter a more secure password.");

			} else if (passTxt.text != passConfTxt.text) {

			Dialogs.showOkDialog("Your password isn't the same in both cases. Make sure you enter it carefully!");
		    }
		    else {

			Global.isLocked = true;
			new AdminService(passresult).changeSecurePassword(Strings.trim(passTxt.text));

			}
		}

		private function passresult(success:Boolean):void
		{
			Global.isLocked = false;
			if(success)
			succeed();
			else
			Dialogs.showOkDialog("Your password needs to be changed. Don't keep it the same!")
		}

		private function succeed():void
		{
			hide();
			Global.charManager.resetPass = false;
			Global.enteredPassword = (Strings.trim(passTxt.text));
		}
		
		private function onResult(success:Boolean):void
		{

		}
	}
}