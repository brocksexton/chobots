package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.McLevelEffect;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.Event;
	
	public class LevelAnimCommand
	{
		private var _exp:int;
		private var _effect:McLevelEffect;
		
		public function LevelAnimCommand(experience:int)
		{
			_exp = experience;
		}
		
		public function execute():void
		{
			_effect = new McLevelEffect();
			_effect.Symbolsa.experience = (_exp > 0 ? '+' : '') + _exp.toString();
			_effect.Symbolsa.addEventListener(Event.COMPLETE, onAnimationComplete);
			
			Global.root.addChild(_effect);
			Global.playSound(LevelSound);
		}
		
		private function onAnimationComplete(e:Event):void
		{
			_effect.stop();
			GraphUtils.detachFromDisplay(_effect);
		}
	
	}
}