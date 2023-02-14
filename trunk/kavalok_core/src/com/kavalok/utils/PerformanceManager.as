package com.kavalok.utils
{
	import com.kavalok.Global;
	
	import flash.events.Event;
	
	import com.kavalok.events.EventSender;
	
	public class PerformanceManager
	{
		static private const UPDATE_INTERVAL:Number = 20000; // miliseconds
		static private const MIN_FRAMERATE:Number = 15;
		
		private var _shadowEnabled:Boolean = true;
		private var _shadowEnabledChanged:EventSender = new EventSender();
		
		private var _time:Number;
		private var _framerate:Number;
		private var _quality:int;
		
		public function PerformanceManager()
		{
			Global.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_framerate = 0;
			_time = new Date().time;
		}
		
		private function onEnterFrame(e:Event):void
		{
			_framerate++;
			var currentTime:Number = new Date().time; 
			var interval:Number = currentTime - _time;
			
			if (interval >= UPDATE_INTERVAL)
			{
				_framerate /= interval * 0.001;
				
				if (_framerate < MIN_FRAMERATE)
				{
					if (quality > 0)
						quality--;
				}
				
				_framerate = 0;
				_time = currentTime;
			}
		}
		
		public function get quality():int
		{
			return _quality;
		}
		
		public function set quality(value:int):void
		{
			_quality = value;
			
			if (_quality == 0)
			{
				shadowEnabled = false;
				Global.stage.quality = 'medium';
			}
			else if (_quality == 1)
			{
				shadowEnabled = false;
				Global.stage.quality = 'high';
			}
			else if (_quality == 2)
			{
				shadowEnabled = true;
				Global.stage.quality = 'high';
			}
		}
		
		public function get shadowEnabled():Boolean
		{
			 return _shadowEnabled;
		}
		
		public function set shadowEnabled(value:Boolean):void
		{
			if (value != _shadowEnabled)
			{
				_shadowEnabled = value;
				_shadowEnabledChanged.sendEvent();
			}
		}
		
		public function get shadowEnabledChanged():EventSender
		{
			 return _shadowEnabledChanged;
		}

	}
}