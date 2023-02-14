package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.fightAction.ThrowMashinGunAction;
	
	public class MashinGunAction extends ThrowAction
	{
		public function MashinGunAction()
		{
			super(ThrowMashinGunAction);

			_showModel = WMashinGunShow;
			fightModel = WMashinGunFight;
			_shellModels = [WMashinGunShell];
			_countTotal = 3;
		}
		
		override public function get id():String
		{
			return "weaponMashinGun";
		}
		
	}
}