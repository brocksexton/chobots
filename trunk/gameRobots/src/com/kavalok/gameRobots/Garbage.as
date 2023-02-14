
package com.kavalok.gameRobots
{
	import com.kavalok.utils.EventManager;
	import flash.events.Event;

	public class Garbage
	{
		private var _content:McGarbage;
		private var _frameNum:int;
		private var _events:EventManager;
		
		public function Garbage(content:McGarbage, events:EventManager)
		{
			_content = content;
			_content.stop();
			_events = events;
			opened = false;
		}
		
		public function set opened(value:Boolean):void
		{
			if (value && _content.currentFrame != _content.totalFrames)
				startAnimation(_content.totalFrames);
			
			if (!value && _content.currentFrame != 1)
				startAnimation(1);
		}
		
		private function startAnimation(frameNum:int):void
		{
			_frameNum = frameNum;
			_events.registerEvent(_content, Event.ENTER_FRAME, onFrame);
		}
		
		private function stopAnimation():void
		{
			_events.removeEvents(_content);
		}
		
		private function onFrame(e:Event):void
		{
			if (_content.currentFrame < _frameNum)
				_content.nextFrame();
			else if (_content.currentFrame > _frameNum)
				_content.prevFrame();
			else
				stopAnimation();
		}
		
	}
	
}
