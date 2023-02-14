package com.kavalok.services
{
	import com.kavalok.Global;
	import flash.external.ExternalInterface;
	public class MoneyService extends SecuredRed5ServiceBase
	{
		public function MoneyService(resultHandler:Function = null)
		{
			super(resultHandler);
		}
		
		public function addMoney(money : int, reason : String) : void
		{
			ExternalInterface.call("console.log", Global.charManager.privKey);
			privAddMoney(money, reason, Global.charManager.privKey);
		}
		
		public function privAddMoney(money : int, reason : String, privKey : String) : void
		{
			doCall("addMoney", arguments);
		}
		
		public function addEmeralds(emeralds : int, reason : String) : void
		{
			privAddEmeralds(emeralds, reason, Global.charManager.privKey);
		}
		
		public function privAddEmeralds(emeralds : int, reason : String, privKey : String) : void
		{
			doCall("addEmeralds", arguments);
		}
		
	}
}