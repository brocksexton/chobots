package com.kavalok.loaders
{
	import com.kavalok.utils.Maths;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class LocationLoaderView extends LoaderViewBase 
	{
		private var _content:McLocationPreloader;
		private var _frameNum:int;
		
		public function LocationLoaderView()
		{
			_content = new McLocationPreloader();
			_content.stop();
			_content.txtPercent.text = '';
		}
		
		override public function set percent(value:int):void
		{
			_frameNum = _content.totalFrames * value / 100;
			_frameNum = Math.min(_frameNum, _content.totalFrames);
			_frameNum = Math.max(_frameNum, 1);
			
			//_content.gotoAndStop(_frameNum);
			_content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_content.txtPercent.text = value.toString() + '%';
			
		}
		
		override public function set text(value:String):void
		{
			 _content.txtPercent.text = value;
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (_content.currentFrame == _frameNum)
			{
				_content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			else
			{
				var distance:int = (_frameNum - _content.currentFrame) / 5;
				
				if (distance == 0)
					distance = _frameNum - _content.currentFrame;
					
				_content.gotoAndStop(_content.currentFrame + distance);
				
			}
		}
		
		override public function get content():Sprite { return _content; }
	}
}