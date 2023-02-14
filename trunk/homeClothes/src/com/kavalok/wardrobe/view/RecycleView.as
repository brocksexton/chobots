package com.kavalok.wardrobe.view
{
	import com.kavalok.utils.MoviePlayer;
	
	import flash.display.MovieClip;
	
	public class RecycleView
	{
		private var _content:MovieClip
		private var _moviePlayer:MoviePlayer
		
		public function RecycleView(content:MovieClip)
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
			_moviePlayer.playTo(10);	
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