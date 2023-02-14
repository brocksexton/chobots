package com.kavalok.pinball
{
	import flash.display.MovieClip;
	
	import com.kavalok.utils.GraphUtils;
	
	public class BallsView
	{
		private var _content : MovieClip;
		private var _balls : int;
		
		public function BallsView(content : MovieClip, balls : int)
		{
			_content = content;
			_balls = balls;
			update();
		}
		
		public function set balls(value : int) : void
		{
			_balls = value;
			update();
		}
		
		public function get balls() : int
		{
			return _balls;
		}
		
		private function update() : void
		{
			GraphUtils.removeChildren(_content);
			for(var i : int = 0; i < balls; i++)
			{
				var child : Ball = new Ball();
				child.x = i * 24;
				_content.addChild(child);
			}
		}
		

	}
}