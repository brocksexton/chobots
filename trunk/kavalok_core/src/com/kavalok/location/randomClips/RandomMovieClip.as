package com.kavalok.location.randomClips
{
	import com.kavalok.Global;
	import com.kavalok.utils.RandomTimer;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class RandomMovieClip
	{
		public static const RANDOM_CLIP_PREFIX : String = "random_";
		
		private var _movieClip : MovieClip;
		private var _randomTimer : RandomTimer;
		
		public function RandomMovieClip(movieClip : DisplayObject)
		{
			_movieClip = MovieClip(movieClip);
			_movieClip.gotoAndStop(1);
			_randomTimer = new RandomTimer(_movieClip, 0.25, 100);
			_randomTimer.tick.addListener(showClip);
			_randomTimer.start();
		}
		
		private function showClip():void
		{
			if (Global.locationManager.location && 
				Global.locationManager.location.remote.connectedChars.length < 40)
			{
				_movieClip.addEventListener(Event.ENTER_FRAME, onClipEnterFrame);
				_movieClip.play();
			}
		}
		
		private function onClipEnterFrame(event : Event):void
		{
			if (_movieClip.currentFrame == _movieClip.totalFrames)
			{
				_movieClip.gotoAndStop(1);
				_movieClip.removeEventListener(Event.ENTER_FRAME, onClipEnterFrame);
			}
		}

	}
}