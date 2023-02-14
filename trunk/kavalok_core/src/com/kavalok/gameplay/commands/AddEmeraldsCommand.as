package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.McMoneyEffect;
	import com.kavalok.services.CompetitionService;
	import com.kavalok.services.MoneyService;

	import com.junkbyte.console.Cc; // console
	
	public class AddEmeraldsCommand
	{

		private var _emeralds:int;
		private var _scores:int;
		private var _reason:String;
		private var _setCompetitionScore:Boolean;
		private var _completeHandler:Function;
		private var _effect:McMoneyEffect;
		
		public function AddEmeraldsCommand(emeralds:int, reason:String, completeHandler:Function = null)
		{

			Cc.info("adding emeralds (AddEmeraldsCommand): " + emeralds + " reason: " + reason);

			_emeralds = emeralds;			
			_reason = reason;
			_completeHandler = completeHandler;
		}
		
		public function execute():void
		{
			if (Global.charManager.isGuest)
			{
				Global.charManager.emeralds += _emeralds;
			}
			else
			{
				new MoneyService(onResult).addEmeralds(_emeralds, _reason);
			}
			//new MoneyAnimCommand(_money).execute();
		}
		
		private function onResult(result:Object):void
		{
			if (_completeHandler != null)
				_completeHandler();
		}
	
	}
}