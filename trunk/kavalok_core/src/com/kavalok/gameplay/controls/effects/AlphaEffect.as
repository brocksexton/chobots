package com.kavalok.gameplay.controls.effects
{
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.DisplayObject;

	public class AlphaEffect extends EffectBase
	{
		private var _to : Number;
		private var _frames : int;
		private var _finalVisibility : Boolean;
		
		public function AlphaEffect(to : Number, finalVisibility : Boolean = true, frames : int = 5)
		{
			_to = to;
			_frames = frames;
			_finalVisibility = finalVisibility;
		}

		override public function play(object:DisplayObject):void
		{
			object.visible = true;
			new SpriteTweaner(object, {alpha : _to}, _frames, null, onTweenComplete);
		}
		
		private function onTweenComplete(object : DisplayObject) : void
		{
			finishEvent.sendEvent();
			object.visible = _finalVisibility;
		}
	}
}