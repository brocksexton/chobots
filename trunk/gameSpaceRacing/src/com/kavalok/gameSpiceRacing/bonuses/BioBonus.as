package com.kavalok.gameSpiceRacing.bonuses
{
	import com.kavalok.Global;
	public class BioBonus extends BonusBase
	{
		private var _fuelKoef:Number;
		
		override public function get time():int
		{
			return 5;
		}
		
		override public function apply():void
		{
			Global.playSound(snd_take_bio);
			_fuelKoef = player.fuelKoef;
			player.fuelKoef = 0;
			player.model.mcFire.gotoAndStop(3);
		}
		
		override public function restore():void
		{
			player.fuelKoef = _fuelKoef;
			player.model.mcFire.gotoAndStop(1);
		}
	}
}
