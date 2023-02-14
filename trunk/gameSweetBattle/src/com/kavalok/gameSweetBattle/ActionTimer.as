package com.kavalok.gameSweetBattle 
{
	import com.kavalok.Global;
	import com.kavalok.utils.EventManager;
	
	import flash.events.Event;
	
	import com.kavalok.events.EventSender;
	
	public class ActionTimer
	{
		private var _content:McTimer;
		
		private var _time:int;
		private var _counter:int;
		private var _completeEvent:EventSender = new EventSender();
		
		private var em:EventManager = GameSweetBattle.eventManager;
		
		public function ActionTimer(content:McTimer)
		{
			_content = content;
		}
		
		public function start(time:int):void
		{
			_time = time;
			
			_counter = Global.stage.frameRate;
			
			em.registerEvent(_content, Event.ENTER_FRAME, onFrame);
			
			visible = true;
			
			refresh();
		}
		
		public function resume():void
		{
			start(_time);
		}
		
		private function onFrame(e:Event):void 
		{
			if (--_counter == 0) 
			{
				if (--_time == 0) 
				{
					stop();
					_completeEvent.sendEvent();
				}
				else 
				{
					_counter = Global.stage.frameRate;
				}
				
				refresh();
			}
		}
		
		public function stop():void
		{
			em.removeEvent(_content, Event.ENTER_FRAME, onFrame);
		}
		
		private function refresh():void
		{
			_content.txtCaption.text = _time.toString();
		}
		
		public function set visible(value:Boolean):void 
		{
			_content.visible = value;
		}
		
		public function get time():int { return _time; }
		
		public function set time(value:int):void 
		{
			_time = value;
			refresh();
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
	}
	
}