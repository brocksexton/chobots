package com.kavalok.gameplay.controls.effects
{
	import flash.display.DisplayObject;
	
	public class HideEffect extends EffectBase
	{
		public function HideEffect()
		{
			super();
		}
		
		override public function play(object:DisplayObject):void
		{
			object.visible = false;
			finishEvent.sendEvent();
		}
	}
}