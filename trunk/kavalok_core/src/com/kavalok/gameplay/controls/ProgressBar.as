package com.kavalok.gameplay.controls
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	
	public class ProgressBar
	{
		private var _content:Sprite;
		private var _line:Sprite;
		
		public function ProgressBar(content:Sprite)
		{
			_content = content;
			_line = content['line'];
		}
		
		public function set value(value:Number):void
		{
			 _line.scaleX = GraphUtils.claimRange(value, 0, 1);
		}
		
		public function get value():Number
		{
			 return _line.scaleX;
		}
		
		public function get content():Sprite
		{
			 return _content;
		}

	}
}