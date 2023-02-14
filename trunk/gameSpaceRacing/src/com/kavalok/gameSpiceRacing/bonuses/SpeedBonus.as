package com.kavalok.gameSpiceRacing.bonuses
{
	import com.kavalok.Global;

	public class SpeedBonus extends BonusBase
	{
		private var _maxAcc:Number;
		
		override public function get time():int
		{
			return 5;
		}
		
		override public function apply():void
		{
			Global.playSound(snd_take_fast);
			_maxAcc = player.maxAccY
			player.maxAccY *= 2;
			player.model.mcFire.gotoAndStop(4);
		}
		
		override public function restore():void
		{
			player.maxAccY = _maxAcc;
			player.model.mcFire.gotoAndStop(1);
		}
	}
}
