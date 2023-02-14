package com.kavalok.dialogs
{
	import com.kavalok.Global;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import com.kavalok.services.CharService;
	
	import com.kavalok.events.EventSender;

	public class DialogGirlBoyView extends DialogViewBase
	{
		public var boyButton : SimpleButton;
		public var girlButton : SimpleButton;

		private var _yes : EventSender = new EventSender();
		private var _no : EventSender = new EventSender();

		public function DialogGirlBoyView(text:String, modal : Boolean = true)
		{
			super(new DialogGirlBoy(), text, modal);
		//	Global.resourceBundles.kavalok.registerButton(yesButton, "yes")
		//	Global.resourceBundles.kavalok.registerButton(noButton, "no")
			boyButton.addEventListener(MouseEvent.CLICK, onBoyClick);
			girlButton.addEventListener(MouseEvent.CLICK, onGirlClick);
		}
		
		public function get yes() : EventSender
		{
			return _yes;
		}
		public function get no() : EventSender
		{
			return _no;
		}
		
		private function onBoyClick(event : MouseEvent) : void
		{
			hide();
			new CharService().setGender("boy");
			Global.charManager.gender="boy";
			yes.sendEvent();
		}

		private function onGirlClick(event : MouseEvent) : void
		{
			hide();
			new CharService().setGender("girl");
			Global.charManager.gender="girl";
			no.sendEvent();
		}
	}
}