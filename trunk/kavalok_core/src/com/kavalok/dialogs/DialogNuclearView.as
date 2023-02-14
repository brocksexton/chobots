package com.kavalok.dialogs
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.kavalok.services.AdminService;
	import flash.events.MouseEvent;
	import com.kavalok.Global;
	
	import com.kavalok.events.EventSender;
	
	public class DialogNuclearView extends DialogViewBase
	{
		public var okButton:SimpleButton;
		public var _twitText:String;
		private var _ok:EventSender = new EventSender();
		
		public function DialogNuclearView(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = false, twitterText:String = null)
		{
			super(content || new DialogOk(), text, modal);
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			okButton.visible = okVisible;
			_twitText = twitterText;
		
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
		
		protected function onTwitterClick(e:MouseEvent):void
		{
			new AdminService().sendTweet(Global.charManager.userId, Global.charManager.accessToken, Global.charManager.accessTokenSecret, _twitText);
		}
	
	}
}