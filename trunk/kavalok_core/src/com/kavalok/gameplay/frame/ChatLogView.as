package com.kavalok.gameplay.frame
{
	import com.kavalok.Global;
	import com.kavalok.chat.ChatLog;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.events.EventSender;
	import com.kavalok.events.TargetEvent;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.controls.TextScroller;
	import com.kavalok.gameplay.notifications.INotification;
	import com.kavalok.utils.SpriteTweaner;
	import com.kavalok.utils.Strings;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ChatLogView
	{
		private static const MAX_HISTORY:int = 60;
		private static const DURATION : int = 500;
		private static const OFFSET_X : int = -20;
		private static const OFFSET_Y : int = 7;
		private static const TWEEN_OFFSET_Y : int = 10;
		
		private var _chooseRecipient : EventSender = new EventSender(TargetEvent);
		private var _content : ChatLog;
		private var _scroller : TextScroller;
		private var _open : Boolean;
		private var _tweener : SpriteTweaner;
		private var _chatHistory:Array = [];
		
		public function ChatLogView(content:ChatLog)
		{
			trace("checkpoint 2");
			_content = content;
			content.y += OFFSET_Y;
			content.x += OFFSET_X;
			content.scrollRect = new Rectangle(OFFSET_X, OFFSET_Y, _content.width - OFFSET_X , - content.height);
			
			_content.openCloseButton.addEventListener(MouseEvent.CLICK, onOpenCloseClick);
			ToolTips.registerObject(_content.openCloseButton, "chatHistory", ResourceBundles.KAVALOK);
			
			_scroller = new TextScroller(_content.mcVertScroll, _content.chatTextField);
			trace("checkpoint 3");
		}
		
		public function get open() : Boolean
		{
			return _open;
		}
		public function set open(value : Boolean) : void
		{
			if(open != value)
			{
				_open = value;
				var targetPosition : int = value ? _content.mcVertScroll.height + TWEEN_OFFSET_Y: OFFSET_Y;
				onTweenUpdate(targetPosition);
				if (_open)
					refresh();
			}
		}
		
		public function get chooseRecipient() : EventSender
		{
			return _chooseRecipient;
		}
		
		public function showNotification(notification:INotification) : void
		{
			if (_chatHistory.length >= MAX_HISTORY)
				_chatHistory.shift();
			
			var messageText:String = getMessageText(notification);
			_chatHistory.push(messageText);
			
			if (open)
				refresh();

				trace("checkpoint 4");
		}
		
		private function refresh():void
		{
			_content.chatTextField.htmlText = _chatHistory.join('\n');
			_scroller.position = 1;
			_scroller.updateScrollerVisible();

			trace("checkpoint 5");
		}
		
		private function getMessageText(notification:INotification):String
		{
			var isMy:Boolean = (notification.fromUserId == Global.charManager.userId);
			var format:String = (isMy)
				? KavalokConstants.MY_MESSAGE_FORMAT
				: KavalokConstants.OTHERS_MESSAGE_FORMAT;
			
			return Strings.substitute(format, notification.fromLogin, notification.getText());
		}
		
		private function onTweenEnd(value : Number) : void
		{
			
		}
		private function onTweenUpdate(value : Number) : void
		{
			var scrollRect : Rectangle = _content.scrollRect;
			scrollRect.y = value
			_content.scrollRect = scrollRect;
		}
		private function onOpenCloseClick(event : MouseEvent) : void
		{
			open = !open;
		}
		
		
		
	}
}