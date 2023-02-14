package com.kavalok.gameSpiceRacing.bonuses
{
	import com.kavalok.gameSpiceRacing.Config;
	import com.kavalok.Global;
	public class FuelBonus extends BonusBase
	{
		override public function apply():void
		{
			Global.playSound(snd_take_fuel);
			player.fuel = Math.min(player.fuel + 0.33, 1);
			player.model.mcFire.gotoAndStop(1);
		}
	}
}
