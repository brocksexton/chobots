package com.kavalok.dialogs
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.kavalok.services.AdminService;
	import flash.events.MouseEvent;
	import com.kavalok.Global;
	
	import com.kavalok.events.EventSender;
	
	public class DialogErrorView extends DialogViewBase
	{
		public var okButton:SimpleButton;

		private var _ok:EventSender = new EventSender();
		
		public function DialogErrorView(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = false)
		{
			super(content || new DialogError(), text, modal);
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			okButton.visible = false;
			
		
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