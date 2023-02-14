package com.kavalok.dialogs
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.kavalok.services.AdminService;
	import flash.events.MouseEvent;
	import com.kavalok.Global;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import com.kavalok.gameplay.commands.AddMoneyCommand;

	import com.kavalok.events.EventSender;
	
	public class DialogBugsView extends DialogViewBase
	{
		public var okButton:SimpleButton;
		private var _ok:EventSender = new EventSender();
	
		public function DialogBugsView(text:String, modal:Boolean = false)
		{
			super(content || new DialogBugs(), text, modal);
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
		}
		
		public function get ok():EventSender
		{
			return _ok;
		}
		
		protected function onOkClick(event:MouseEvent):void
		{
			hide();
			ok.sendEvent();
		}
		
	
	}
}