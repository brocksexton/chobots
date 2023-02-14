package com.kavalok.char
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.chat.BubbleStyle;
	import com.kavalok.gameplay.chat.BubbleStyles;
	import com.kavalok.gameplay.chat.ChatBubbleView;
	import com.kavalok.gameplay.chat.IBubbleSource;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class ChatMessage
	{
		static public const MIN_TIME:Number = 3000;
		static public const LETTER_TIME:Number = 150;
		static public const BUBBLE_DX:int = -18; 
		
		private var _bubble:ChatBubbleView;
		private var _source:IBubbleSource
		private var _timer:Timer;
		private var _style:BubbleStyle;
		
		public function ChatMessage(source:IBubbleSource)
		{
			_source = source;
		}
		
		public function show(to:String, message:Object, style:BubbleStyle = null):void
		{
			if(message == '')
				return;
				
			if (!style)
				_style = BubbleStyles.defaultStyle;
			
			if(!_bubble)
			{
				_bubble = new ChatBubbleView();
				_bubble.scaleX = _bubble.scaleY = 1/Global.scale;
				_source.content.addEventListener(Event.ENTER_FRAME, onBubbleFrame);
				Global.frame.content.addChild(_bubble);
			}
			else
			{
				_timer.stop();
			}
			
			var messageLength : Number = message is Array ? message.length * 6 : message.length;
			var time:Number = Math.max(LETTER_TIME * messageLength, MIN_TIME);
			
			_bubble.showMessage(to, message, style);
			
			_timer = new Timer(time, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			_timer.start();
			
			updatePosition();
		}

		private function onBubbleFrame(e:Event):void
		{
			updatePosition();
		}
		
		private function updatePosition():void
		{
			var point:Point = _source.bubblePosition;
			GraphUtils.transformCoords(point, _source.content, _bubble.parent);
			
			var newX:int = point.x + BUBBLE_DX;;
			var newY:int = point.y - _bubble.height;
			
			if (newX != _bubble.x || newY != _bubble.y)
			{ 
				_bubble.x = newX;
				_bubble.y = newY;
				GraphUtils.claimBounds(_bubble, KavalokConstants.SCREEN_RECT);
			}
		}
		
		private function onComplete(e:TimerEvent):void
		{
			hide();
		}
		
		public function hide():void
		{
			if (_bubble)
			{
				GraphUtils.detachFromDisplay(_bubble);
				_source.content.removeEventListener(Event.ENTER_FRAME, onBubbleFrame);
				_bubble = null;
			}
		}
	}
}
