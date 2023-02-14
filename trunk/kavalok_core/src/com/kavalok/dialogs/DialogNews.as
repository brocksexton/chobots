package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.Strings;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class DialogNews extends DialogViewBase
	{
		static public const LINK_FORMAT:String = "<u><a href='{0}' target='_blank'>{1}</a></u>" 
		
		public var okButton:SimpleButton;

		private var _ok:EventSender=new EventSender();

		public function DialogNews(modal:Boolean=false)
		{
			var content:McNewsDialog=new McNewsDialog();
			super(content, null, modal);
			content.blogLink.htmlText = Strings.substitute(LINK_FORMAT,
				Global.serverProperties.blogURL,
				Global.serverProperties.blogURL.replace('http://', ''));
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

