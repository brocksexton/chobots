package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.McMoneyEffect;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.Event;
	
	public class MoneyAnimCommand
	{
		private var _money:int;
		private var _effect:McMoneyEffect;
		
		public function MoneyAnimCommand(money:int)
		{
			_money = money;
		}
		
		public function execute():void
		{
			_effect = new McMoneyEffect();
			_effect.money = (_money > 0 ? '+' : '') + _money.toString();
			_effect.addEventListener(Event.COMPLETE, onAnimationComplete);
			
			Global.root.addChild(_effect);
		}
		
		private function onAnimationComplete(e:Event):void
		{
			_effect.stop();
			GraphUtils.detachFromDisplay(_effect);
		}
	
	}
}