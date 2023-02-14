package com.kavalok.utils
{
	import com.kavalok.events.EventSender;
	
	public class TaskCounter
	{
		private var _numTasks:int = 0;
		private var _completeEvent:EventSender = new EventSender();
		
		public function TaskCounter(numTasks:int = 0)
		{
			_numTasks = numTasks;
		}
		
		public function get isEmpty():Boolean
		{
			return _numTasks == 0;
		}
		
		public function addCount(value:int = 1):void
		{
			_numTasks += value;
		}
		
		public function set numTasks(value:int):void
		{
			 _numTasks = value;
		}
		
		public function completeTask(dummy:Object = null):void
		{
			if (--_numTasks == 0)
			{
				_completeEvent.sendEvent();
			}
		}
		
		public function get completeEvent():EventSender
		{
			return _completeEvent;
		}

	}
}