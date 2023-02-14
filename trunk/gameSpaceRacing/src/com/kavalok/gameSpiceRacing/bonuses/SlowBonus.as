package com.kavalok.gameSpiceRacing.bonuses
{
	import com.kavalok.Global;
	public class SlowBonus extends BonusBase
	{
		private var _maxAcc:Number;
		
		override public function get time():int
		{
			return 3;
		}
		
		override public function apply():void
		{
			Global.playSound(snd_take_slow);
			_maxAcc = player.maxAccY;
			player.maxAccY *= 0.5;
			player.model.mcFire.gotoAndStop(2);
		}
		
		override public function restore():void
		{
			player.maxAccY = _maxAcc;
			player.model.mcFire.gotoAndStop(1);
		}
	}
}
