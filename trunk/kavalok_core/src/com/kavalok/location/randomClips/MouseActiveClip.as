package com.kavalok.location.randomClips
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.kavalok.utils.Maths;
	import com.kavalok.utils.Timers;
	
	public class MouseActiveClip
	{
		public static const VARIABLE_CLIP_PREFIX : String = "active";  
		
		private var _movieClip : MovieClip;
		private var subClip : MovieClip;
		
		public function MouseActiveClip(movieClip : DisplayObject)
		{
			_movieClip = MovieClip(movieClip);
			_movieClip.gotoAndStop(1);
			_movieClip.addEventListener(MouseEvent.MOUSE_OVER, onMovieClipMouseOver);
		}
		
		private function onMovieClipMouseOver(event : Event):void
		{
			if(subClip != null)
				return;
			
			_movieClip.gotoAndStop(Maths.random(_movieClip.totalFrames - 1) + 2);
			Timers.callAfter(startAnimation);
		}
		
		private function findSubMovieClip():MovieClip
		{
			var result : MovieClip = null;
			
			for (var i:int = 0; i < _movieClip.numChildren; i++)				
			{
				if (_movieClip.getChildAt(i) is MovieClip)
				{
					result = MovieClip(_movieClip.getChildAt(i));
					return result; 
				}
			}
			return result;
		}
		
		private function startAnimation():void
		{
			subClip = findSubMovieClip();
			if(subClip != null)
			{
				subClip.addEventListener(Event.ENTER_FRAME, onSubClipEnterFrame);
			}
		}
		
		private function onSubClipEnterFrame(event : Event):void
		{
			if (subClip.currentFrame == subClip.totalFrames)
			{
				subClip.gotoAndStop(1);
				_movieClip.gotoAndStop(1);
				subClip.removeEventListener(Event.ENTER_FRAME, onSubClipEnterFrame);	
				subClip = null;	
			}
		}
		
	}
}