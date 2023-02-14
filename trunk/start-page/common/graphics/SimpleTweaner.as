package common.graphics
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class SimpleTweaner
	{
		public var updateHandler:Function;
		
		private var _completeHandler:Function;
		private var _properties:Object;
		private var _sprite:DisplayObject;
		private var _counter:Number;
		private var _incr:Object = {};
		
		public function SimpleTweaner(sprite:DisplayObject, properties:Object, frames:int, onComplete:Function = null)
		{
			_sprite = sprite;
			_properties = properties;
			_counter = frames;
			_completeHandler = onComplete;
			
			for (var prop:String in properties)
			{
				_incr[prop] = (_properties[prop] - sprite[prop]) / _counter;
			}
			
			_sprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
				if (_completeHandler != null)
					_completeHandler(_sprite);
			}
		}
		
		public function stop():void
		{
			_sprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
	}
	
}