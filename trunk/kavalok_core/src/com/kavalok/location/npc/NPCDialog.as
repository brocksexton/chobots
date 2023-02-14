package com.kavalok.location.npc
{
	import com.kavalok.Global;
	import com.kavalok.char.ChatMessage;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.chat.ChatBubbleView;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class NPCDialog
	{
		private var _messages:Array;
		private var _completeEvent:EventSender = new EventSender();
		
		private var _messageNum:int;
		private var _bubble:ChatBubbleView = new ChatBubbleView();
		private var _npc:NPCChar;
		private var _timer:Timer;
		
		public function NPCDialog(npc:NPCChar)
		{
			_npc = npc;
		}
		
		public function showDialog(messages:Array):void
		{
			stop();
			
			_messages = messages;
			_messageNum = 0;
			
			Global.topContainer.addChild(_bubble);
			
			showNextMessage();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_messageNum++;
			
			if (_messageNum < _messages.length)
			{
				showNextMessage();
			}
			else
			{
				stop();
				_completeEvent.sendEvent();
			}
		}
		
		private function showNextMessage():void
		{
			var message:String = _messages[_messageNum];
			
			_bubble.showMessage(Global.charManager.charId, message);
			
			var bounds:Rectangle = _npc.content.getBounds(Global.topContainer);
			
			_bubble.x = bounds.left + 0.5 * bounds.width; 
			_bubble.y = bounds.top - _bubble.height;
			
			var time:int = ChatMessage.LETTER_TIME * message.length;
			
			_timer = new Timer(Math.min(time, ChatMessage.MIN_TIME), 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			_timer.start();
		}
		
		public function stop():void
		{
			GraphUtils.detachFromDisplay(_bubble);
			
			if (_timer)
				_timer.stop();
		}

		public function get completeEvent():EventSender { return _completeEvent; }
	}
}