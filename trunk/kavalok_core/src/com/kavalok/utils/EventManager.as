package com.kavalok.utils 
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	/**
	 * Class stores all added listeners and make possible to clear they.
	 * Main purpose is clear EnderFrame, Timer and other events when some engine finished; 
	 */
	public class EventManager 
	{
		private var _eventList:Array = [];
		
		public function registerEvent(object:EventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			object.addEventListener(type, listener, useCapture);
			
			if (getEventIndex(object, type, listener, useCapture) == -1)
			{
				_eventList.push(new EventItem(object, type, listener, useCapture));
			}
		}
		
		public function removeEvent(object:EventDispatcher, type:String, listener:Function = null, useCapture:Boolean = false):void
		{
			if (listener != null)
			{
				object.removeEventListener(type, listener, useCapture);
				var Index:int = getEventIndex(object, type, listener, useCapture);
				if (Index >= 0)
				{
					_eventList.splice(Index, 1);
				}
			}
			else
			{
				var i:int = 0;
				while (i < _eventList.length)
				{
					var o:EventItem = _eventList[i];
					if (o.object == object && o.type == type)
					{
						object.removeEventListener(o.type, o.listener, o.useCapture);
						_eventList.splice(i, 1);
					}
					else
					{
						i++;
					}
				}
			}
		}
		
		public function removeEvents(object:EventDispatcher):void
		{
			var i:int = 0;
			while (i < _eventList.length)
			{
				var o:EventItem = _eventList[i];
				if (o.object == object)
				{
					object.removeEventListener(o.type, o.listener, o.useCapture);
					_eventList.splice(i, 1);
				}
				else
				{
					i++;
				}
			}
		}
		
		public function clearEvents():void
		{
			for (var i:int = 0; i < _eventList.length; i++)
			{
				var item:EventItem = _eventList[i];
				item.object.removeEventListener(item.type, item.listener, item.useCapture)
			}
			
			_eventList = [];
		}
		
		public function eventExists(object:EventDispatcher, type:String, listener:Function, useCapture:Boolean = false):Boolean
		{
			return ( getEventIndex(object, type, listener, useCapture) >= 0 );
		}
		
		private function getEventIndex(object:EventDispatcher, type:String, listener:Function, useCapture:Boolean):int
		{
			for (var i:int = 0; i < _eventList.length; i++)
			{
				var o:EventItem = _eventList[i];
				if (o.object == object && o.type == type && o.listener == listener && o.useCapture == useCapture)
				{
					return i;
				}
			}
			return -1;
		}
	}
}

import flash.events.EventDispatcher;

internal class EventItem
{
	public var object:EventDispatcher;
	public var type:String;
	public var listener:Function;
	public var useCapture:Boolean;
	
	function EventItem(object:EventDispatcher, type:String, listener:Function, useCapture:Boolean):void
	{
		this.object = object;
		this.type = type;
		this.listener = listener;
		this.useCapture = useCapture;
	}
	
}
