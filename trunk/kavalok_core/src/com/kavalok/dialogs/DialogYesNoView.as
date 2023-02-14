package com.kavalok.dialogs
{
	import com.kavalok.Global;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	
	import com.kavalok.events.EventSender;

	public class DialogYesNoView extends DialogViewBase
	{
		public var yesButton : SimpleButton;
		public var noButton : SimpleButton;
		public var colourSprite:Sprite;

		private var _yes : EventSender = new EventSender();
		private var _no : EventSender = new EventSender();

		public function DialogYesNoView(text:String, modal : Boolean = true)
		{
			super(new DialogYesNo(), text, modal);
			Global.resourceBundles.kavalok.registerButton(yesButton, "YES")
			Global.resourceBundles.kavalok.registerButton(noButton, "NO")
			yesButton.addEventListener(MouseEvent.CLICK, onYesClick);
			noButton.addEventListener(MouseEvent.CLICK, onNoClick);
			Global.applyUIColour(colourSprite);
		}
		
		public function get yes() : EventSender
		{
			return _yes;
		}
		public function get no() : EventSender
		{
			return _no;
		}
		
		private function onYesClick(event : MouseEvent) : void
		{
			hide();
			yes.sendEvent();
		}

		private function onNoClick(event : MouseEvent) : void
		{
			hide();
			no.sendEvent();
		}
	}
}