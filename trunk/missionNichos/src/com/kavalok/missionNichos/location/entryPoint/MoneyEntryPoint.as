package com.kavalok.missionNichos.location.entryPoint
{
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.entryPoints.EntryPointBase;
	
	import flash.display.MovieClip;

	public class MoneyEntryPoint extends EntryPointBase
	{
		
		public function MoneyEntryPoint(location:LocationBase)
		{
			super(location, "money_", null);
		}
		
		override public function initialize(clip : MovieClip):void
		{
			clip.buttonMode = true;
			clip.useHandCursor = true;
		}
		override public function goIn():void
		{
			super.goIn();
		 	var addMoney : int = clickedClip.name.split("_")[1];
			new AddMoneyCommand(addMoney, "nichosMission").execute();
		 	clickedClip.visible = false;
		}
		
	}
}