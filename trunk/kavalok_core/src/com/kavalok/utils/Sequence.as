package com.kavalok.utils
{
	import flash.display.DisplayObject;
	
	import com.kavalok.utils.Arrays;
	
	public class Sequence
	{
		private var _sprite : DisplayObject;
		private var _properties : Array;
		private var _framesPerStep : uint;
		private var _completeHandler : Function;
		private var _infinite : Boolean;
		private var _startProperties : Array;
		private var _stop : Boolean;
		
		
		
		public function Sequence(sprite:DisplayObject, properties:Array, framesPerStep:uint, completeHandler : Function = null, infinite : Boolean = false)
		{
			_sprite = sprite;
			_infinite = infinite;
			_properties = properties;
			_startProperties = Arrays.clone(properties);
			_framesPerStep = framesPerStep;
			_completeHandler = completeHandler;
			processStep();
		}
		
		public function stop() : void
		{
			_stop = true;
		}
		
		private function processStep() : void
		{
			if(_properties.length > 0 && !_stop)
			{
				var props : Object = _properties.shift();
				new SpriteTweaner(_sprite, props, _framesPerStep, null, onStepComplete);
			}
			else
			{
				if(_completeHandler != null)
					_completeHandler();
			}
		}
		
		private function onStepComplete(sender:DisplayObject) : void
		{
			if(_infinite && _properties.length == 0)
			{
				_properties = Arrays.clone(_startProperties);
			}
			processStep();
		}

	}
}