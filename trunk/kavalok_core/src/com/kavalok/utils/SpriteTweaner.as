package com.kavalok.utils 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.kavalok.events.EventSender;
	
	public class SpriteTweaner 
	{
		public var updateHandler:Function;
		private var _completeHandler:Function;
		private var _em:EventManager;
		private var _properties:Object;
		private var _sprite:DisplayObject;
		private var _counter:Number;
		private var _incr:Object = {};
		private var _complete:EventSender = new EventSender();
		
		public function SpriteTweaner(sprite:DisplayObject, properties:Object, frames:int, em:EventManager = null, onComplete:Function = null)
		{
			_em = (em == null) ? new EventManager() : em;
			
			_sprite = sprite;
			_properties = properties;
			_counter = frames;
			_completeHandler = onComplete;
			
			for (var prop:String in properties)
			{
				_incr[prop] = (_properties[prop] - sprite[prop]) / _counter;
			}
			
			_em.registerEvent(sprite, Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function get complete() : EventSender
		{
			return _complete;
		}
		
		private function onEnterFrame(e:Event):void
		{
			for (var prop:String in _incr)
			{
				_sprite[prop] += _incr[prop];
				if(updateHandler != null)
					updateHandler(prop, _incr[prop])
			}
			
			if (--_counter == 0) 
			{
				stop();
				complete.sendEvent();
				
				if (_completeHandler != null) 
				{
					_completeHandler(_sprite);
				}
			}
		}
		
		public function stop():void
		{
			for (var prop:String in _properties)
			{
				_sprite[prop] = _properties[prop];
			}
			
			_em.removeEvent(_sprite, Event.ENTER_FRAME, onEnterFrame);
			
		}
		
	}
	
}