package com.kavalok.utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class ZOrder
	{
		private var _content:Sprite;
		
		public function ZOrder(content:Sprite)
		{
			_content = content;
			
			_content.addEventListener(Event.ADDED_TO_STAGE, startMonitoring);
			_content.addEventListener(Event.REMOVED_FROM_STAGE, stopMonitoring);
			
			if (_content.stage)
				startMonitoring();
		}
		
		private function startMonitoring(e:Event = null):void
		{
			_content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function stopMonitoring(e:Event = null):void
		{
			_content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (_content.numChildren == 0)
				return;
			
			var prevChild:DisplayObject = _content.getChildAt(0);
			
			for (var i:int = 1; i < _content.numChildren; i++)
			{
				var currentChild:DisplayObject = _content.getChildAt(i);
				
				if (currentChild.y < prevChild.y)
				{
					var j:int = i - 1;
					
					while (j >= 0 && currentChild.y < _content.getChildAt(j).y)
					{
						j--;
					}
					
					_content.setChildIndex(currentChild, j + 1);
				}
				else
				{
					prevChild = currentChild;
				}
			}
			
		}
		
	}
}