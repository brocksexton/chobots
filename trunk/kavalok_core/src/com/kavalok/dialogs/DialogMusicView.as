package com.kavalok.dialogs
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import com.kavalok.events.EventSender;

	public class DialogMusicView extends DialogViewBase
	{
		public var okButton : SimpleButton;
		
		private var _ok : EventSender = new EventSender();
		
		public function DialogMusicView(text:String, okVisible : Boolean = true, content : MovieClip = null, modal : Boolean = false)
		{
			super(content || new DialogMusic(), text, modal);
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			okButton.visible = okVisible;
		}
		
		public function get ok() : EventSender
		{
			return _ok;
		}
		
		protected function onOkClick(event : MouseEvent) : void
		{
			hide();
		}
		
	}
}