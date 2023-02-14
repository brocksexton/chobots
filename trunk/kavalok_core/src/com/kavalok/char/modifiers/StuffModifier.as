package com.kavalok.char.modifiers
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.constants.StuffTypes;
	
	import flash.display.MovieClip;
	
	public class StuffModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 120;
		static private const ANIMATION_CLASS:String = "McModifier";
		
		private var _fileName:String;
		private var _animation:MovieClip;
		private var _restored:Boolean = false;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		private function get url():String
		{
			return URLHelper.stuffURL(_fileName, StuffTypes.STUFF);
		}
		
		override protected function apply():void
		{
			_fileName = String(_parameter);
			Global.classLibrary.callbackOnReady(showAnimation, [url]);
		}
		
		private function showAnimation():void
		{
			if (!_restored)
			{
				_animation = MovieClip(Global.classLibrary.getInstance(url, ANIMATION_CLASS));
				_char.content.addChildAt(_animation, 0);
			}
		}
		
		override protected function restore():void
		{
			_restored = true;
			
			if (_animation)
			{
				_animation.stop();
				_char.content.removeChild(_animation)
				_animation = null;
			} 
		}

	}
}