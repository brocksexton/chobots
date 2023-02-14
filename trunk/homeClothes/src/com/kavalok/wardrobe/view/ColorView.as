package com.kavalok.wardrobe.view
{
	import com.kavalok.utils.MoviePlayer;
	
	import flash.display.MovieClip;
	
	public class ColorView
	{
		private var _content:MovieClip
		private var _moviePlayer:MoviePlayer
		
		public function ColorView(content:MovieClip)
		{
			_content = content;
			_moviePlayer = new MoviePlayer(_content);
		}
		
		public function playToEnd():void
		{
			_moviePlayer.playToEnd();
		}
		
		public function open():void
		{
			_moviePlayer.playTo(11);	
		}
		
		public function close():void
		{
			_moviePlayer.playTo(1);	
		}
		
		public function hitTestItem(item:ItemSprite):Boolean
		{
			return _content.hitTestObject(item);
		}

	}
}