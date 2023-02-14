package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.fightAction.ThrowPlateAction;
	
	public class PlateAction extends ThrowAction
	{
		public function PlateAction()
		{
			super(ThrowPlateAction);

			_showModel = WPlateShow;
			fightModel = WPlateFight;
			_shellModels = [WPlateShell];
			_countTotal = 3;
		}
		
		override public function get id():String
		{
			return "weaponPlate";
		}
	}
}