package com.kavalok.char.modifiers
{
	import com.kavalok.Global;
	import com.kavalok.char.LocationChar;
	import com.kavalok.errors.NotImplementedError;
	import com.kavalok.location.LocationBase;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	public class CharModifierBase
	{
		protected var _char:LocationChar;
		protected var _parameter:Object;
		
		private var _timer:Timer;
		
		public function CharModifierBase()
		{
		}
		
		public function execute():void
		{
			 if (_char.isUser)
			 {
				 if (timeout > 0 && !('noTimeLimit' in _parameter))
				 	applyTimeout();
			 }
			 
			 if (_char.model.isReady)
			 {
				 apply();
			 }
			 else
			 {
			 	_char.model.readyEvent.addListener(onCharReady);
			 }
		}
		
		public function get timeoutEnabled():Boolean
		{
			 return 'timeLimit' in _parameter && _parameter.timeLimit ;
		}
		
		private function onCharReady():void
		{
			_char.model.readyEvent.removeListener(onCharReady);
			apply();
		}
		
		private function applyTimeout():void
		{
			 var usedTime:int = Global.charManager.actionsTime[className];
			 
			 _timer = new Timer(1000, timeout - usedTime);
			 _timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			 _timer.start();
			 
			 Global.locationManager.locationDestroy.addListener(saveTimeout);
		}
		
		private function saveTimeout():void
		{
			Global.locationManager.locationDestroy.removeListener(saveTimeout);
			Global.charManager.actionsTime[className] = 
				int(Global.charManager.actionsTime[className]) + _timer.currentCount;
		}
		
		public function get className():String
		{
			 return getQualifiedClassName(this);
		}
		
		public function set char(value:LocationChar):void
		{
			 _char = value;
		}
		
		public function get parameter():Object
		{
			 return _parameter;
		}
		
		public function set parameter(value:Object):void
		{
			 _parameter = value;
		}
		
		public function get timeout():int
		{
			return 0;
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			Global.locationManager.locationDestroy.removeListener(saveTimeout);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer = null;
			Global.charManager.removeModifier(className);
		}
		
		protected function apply():void
		{
			throw new NotImplementedError('apply not implemented');
		}
		
		protected function restore():void
		{
			throw new NotImplementedError('apply not implemented');
		}
		
		public function destroy():void
		{
			if (_char.model.readyEvent.hasListener(onCharReady))
				_char.model.readyEvent.removeListener(onCharReady);
			
			if (_timer)
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
								
			restore();
		}
		
		protected function get location():LocationBase
		{
			return Global.locationManager.location
		}
		
	}
}