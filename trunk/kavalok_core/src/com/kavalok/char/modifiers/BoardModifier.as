package com.kavalok.char.modifiers
{
	import com.kavalok.char.CharModels;
	import com.kavalok.char.LocationChar;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class BoardModifier extends CharModifierBase
	{
		static private const IDLE_INTERVAL:int = 3; //seconds
		
		private var _modelTweaner:SpriteTweaner;
		private var _shadowTweaner:SpriteTweaner;
		private var _timer:Timer = new Timer(1000 * IDLE_INTERVAL, 1);
		
		override protected function apply():void
		{
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			
			_char.speed = speed;
			_char.moveStartEvent.addListener(onStartMove);
			_char.moveCompleteEvent.addListener(onFinishMove);
		}
		
		override protected function restore():void
		{
			_char.flyMode = false;
			_char.speed = LocationChar.DEFAULT_SPEED;
			_timer.stop();
			
			_char.moveStartEvent.removeListener(onStartMove);
			_char.moveCompleteEvent.removeListener(onFinishMove);
			
			turnOff();
		}
		
		private function onStartMove():void
		{
			if (!_char.flyMode)
				turnOn();
				
			_timer.stop();
		}
		
		private function onFinishMove():void
		{
			_timer.reset();
			_timer.start();
		}
		
		private function onTimer(e:Event):void
		{
			if (_char.flyMode)
				turnOff();
		}
		
		private function turnOn():void
		{
			_char.flyMode = true;
			_char.model.assetsAnimation = true;
			_char.setModel(CharModels.STAY);
			setCharPosition(-height, 0.5 * height);
		}
		
		private function turnOff():void
		{
			_char.flyMode = false;
			_char.model.assetsAnimation = false;
			setCharPosition(0, 0);
		}
		
		private function setCharPosition(modelPos:int, shadowPos:int):void
		{
			if (!_char.modelAnimation)
				return;
			
			if (_modelTweaner)
				_modelTweaner.stop();
			_modelTweaner = new SpriteTweaner(_char.model, {y: modelPos}, 5);
			
			if (_shadowTweaner)
				_shadowTweaner.stop();
			if (_char.shadow)
				_shadowTweaner = new SpriteTweaner(_char.shadow, {x: shadowPos}, 5);
		}
		
		public function get speed():int
		{
			 return _parameter.speed;
		}

		public function get height():int
		{
			 return _parameter.height;
		}
	}
}