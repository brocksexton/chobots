package com.kavalok.external
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogBuyAccount;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.events.EventSender;
	import com.kavalok.modules.ModuleBase;
	
	import flash.external.ExternalInterface;

	public class ExternalCalls
	{
		public static var LOGIN:String="login";
		public static var REGISTER:String="register";
		public static var MEMBERSHIP:String="membership";
		public static var HOMEPAGE:String="homepage";

		public static function callExternal(method:String, ... args):Object
		{
			try
			{
				args.unshift(method);
				return ExternalInterface.call.apply(ExternalInterface, args);
			}
			catch(e:Error)
			{
				trace(e.message + e.getStackTrace());
			}
			return null;
		}

		private var _changeModeEvent:EventSender=new EventSender();

		public function ExternalCalls()
		{
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.addCallback("setMode", setMode);
				}
				catch(e:Error)
				{
					trace('error:', e.message);
				}

			}
		}

		public function get changeModeEvent():EventSender
		{
			return _changeModeEvent;
		}

		public function getMode():String
		{
			if (ExternalInterface.available)
			{
				return String(callExternal("ch_get_mode"));
			}
			return null;
		}

		private var dialogBuyAccountVisible:Boolean=false;
		private var dialogBuyAccount:DialogBuyAccount;

		private function setMode(value:String):void
		{
			switch(value)
			{
//				case HOMEPAGE:
//					if(Global.moduleManager.empty)
//					Global.moduleManager.loadModule(Modules.LOGIN);
//					break;
				case LOGIN:
					if (dialogBuyAccountVisible)
					{
						dialogBuyAccount.closeButton.visible = true;
						dialogBuyAccount.hide();
						Dialogs.BUY_ACCOUNT_OPENED=false;
						dialogBuyAccountVisible=false;
					}
					break;
//				case REGISTER:
//					if(Global.moduleManager.empty)
//					Global.moduleManager.loadModule(Modules.LOGIN);
//					break;
				case MEMBERSHIP:
					tryLoadMembership();
					break;

			}
			changeModeEvent.sendEvent();
		}

		public function doCloseMembership():void
		{
			dialogBuyAccountVisible=false;
		}

		public function tryLoadMembership(module:ModuleBase=null):void
		{
			if (!Dialogs.BUY_ACCOUNT_OPENED)
			{
				dialogBuyAccount=Dialogs.showBuyAccountDialog("site");
				dialogBuyAccount.closeButton.visible = false;
				dialogBuyAccountVisible=true;
				dialogBuyAccount.closeEvent.addListener(doCloseMembership);
			}

		}

//		public function tryLoadMembership(module : ModuleBase = null) : void
//		{
//			Timers.callAfter(loadMembership);
//		}
//		private function loadMembership() : void
//		{
//			if(!Global.moduleManager.loading)
//			{
//				if(!Global.moduleManager.currentModules.contains(Modules.MEMBERSHIP))
//					Global.moduleManager.loadModule(Modules.MEMBERSHIP);
//			}
//			else
//			{
//				Global.moduleManager.currentModuleEvents.loadEvent.addListener(tryLoadMembership);
//			}
//		}

	}
}

