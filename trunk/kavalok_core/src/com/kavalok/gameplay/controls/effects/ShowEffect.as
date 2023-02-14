package com.kavalok.gameplay.controls.effects
{
	import flash.display.DisplayObject;
	
	public class ShowEffect extends EffectBase
	{
		public function ShowEffect()
		{
			super();
		}
		
		override public function play(object:DisplayObject):void
		{
			object.visible = true;
			finishEvent.sendEvent();
		}
	
	}
}