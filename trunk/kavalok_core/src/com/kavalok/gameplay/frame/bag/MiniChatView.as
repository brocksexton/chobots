package com.kavalok.gameplay.frame.bag
{
	import com.kavalok.Global;
	import com.kavalok.char.actions.MagicAction;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.location.commands.StuffRainCommand;
	import com.kavalok.services.MagicServiceNT;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.ui.LoadingSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.events.TargetEvent;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.notifications.INotification;

	import com.kavalok.utils.Strings;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MiniChatView
	{
		static private const MAGIC_PERIOD:int = 15 * 60; //seconds
		
		private var _content:McChatView = new McChatView();
		private var _applyEvent:EventSender = new EventSender();
		private var _loading:LoadingSprite;
		private var _mPeriod:int;
			private var _open : Boolean;
		public var _chatHistory:Array = [];

		public function MiniChatView()
		{
			refresh();
		}
		
	
		public function refresh():void
		{
			_content.chatTextField.htmlText = _chatHistory ? _chatHistory.join('\n') : "hi";
			
		}
		
			public function showNotification(notification:INotification) : void
		{
			if (_chatHistory.length >= 60)
				_chatHistory.shift();
			
			var messageText:String = getMessageText(notification);
			_chatHistory.push(messageText);
		
				refresh();
		}
		
		private function getMessageText(notification:INotification):String
		{
			var isMy:Boolean = (notification.fromUserId == Global.charManager.userId);
			var format:String = (isMy)
				? KavalokConstants.MY_MESSAGE_FORMAT
				: KavalokConstants.OTHERS_MESSAGE_FORMAT;
			
			return Strings.substitute(format, notification.fromLogin, notification.getText());
		}
		
		public function get applyEvent():EventSender
		{
			return _applyEvent;
		}
		
		public function get content():MovieClip
		{
			return _content;
		}

	}
}
