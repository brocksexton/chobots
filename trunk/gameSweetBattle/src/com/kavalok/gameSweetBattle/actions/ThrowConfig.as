package com.kavalok.gameSweetBattle.actions
{
	public class ThrowConfig
	{
		public var fightModel:Class;
		public var showModel:Class;
		public var shellModels:Array;

		public function ThrowConfig(fightModel : Class, showModel : Class, shellModels : Array)
		{
			this.fightModel = fightModel;
			this.showModel = showModel;
			this.shellModels = shellModels;
		}

	}
}