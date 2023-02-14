package com.kavalok.utils
{
	import com.kavalok.Global;
	import com.kavalok.char.LocationChar;
	import com.kavalok.StartupInfo;
	import com.kavalok.char.Char;
	import com.kavalok.char.actions.CharPropertyAction;
	import com.kavalok.char.actions.CharsModifierAction;
	import com.kavalok.char.actions.CharsPropertyAction;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.char.actions.LoadExternalContent;
	import com.kavalok.constants.Modules;
	import com.kavalok.commands.char.GetCharCommand;
	import com.kavalok.commands.location.GotoLocationCommand;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.windows.CharWindowView;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.URLUtil;
	import com.kavalok.char.actions.LocationPropertyAction;
	import com.kavalok.char.actions.PropertyActionBase;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.commands.FlyingPromoCommand;
	import com.kavalok.location.commands.MoveToLocCommand;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.gameplay.windows.ShowCharViewCommand;
	import com.kavalok.location.commands.MoveToLocationCommand;
	import com.kavalok.RankType;
	import com.kavalok.char.CharManager;
	import com.kavalok.char.commands.ModPanelMod;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.CharService;

	public class ModeratorConsole
	{
		public var _hisName:String;
		private var _char:Char;
		
	public function ModeratorConsole()
	{

	}


	
	public function process(message:String):void
	{
		var commands:Array = message.split(';');

		for each (var command:String in commands)
		{
			if (Global.charManager.isModerator){
				processCommand(message);
			} else {
				Dialogs.showOkDialog("-_-", true);
			}
		}
	}



	private function processCommand(command:String):void
	{
		var tokens:Array = command.split(' ');
		var methodName:String = String(tokens[0]).substr(1);
		tokens.splice(0, 1);
		var method:Function = this[methodName];
		method.apply(this, tokens);

	}
	
	public function find(name:String):void
	{
	  new GetCharCommand(name, 0, onViewComplete).execute();
	   _hisName = name;
	}

	public function moveTo(locId:String):void {  
		   if(AdminConsole.roomList.indexOf(locId, 0) != -1){
				var command:MoveToLocationCommand = new MoveToLocationCommand();
				command.locId = locId;
				location.sendCommand(command);
		   } else {
		    //Dialogs.showOkDialog("The entered room does not exist!", true);
		   }
	}

		public function home(name:String):void
		{
		  new GetCharCommand(name, 0, onGetCHome).execute();
		}

		public function reset():void
		{
			if (Global.locationManager.location)
				Global.locationManager.location.sendResetObjectPositions();
		}

		public function unlockLoc():void
		{
			Global.isLocked=false;
			//Unlock the mouse when the location is lagged.
		}
		
		private function onGetCHome (sender:GetCharCommand):void
		{
		  _char = sender.char;
		  if(_char.userId > 1){
		  var params:Object = new Object();
          params.charId = _char.id;
          params.userId = _char.userId;
          new GotoLocationCommand("home", params).execute();
		  }else{
		  Dialogs.showOkDialog("That user does not exist!", true);
		  }
		}
	
		private function onViewComplete(sender:GetCharCommand):void
		{
			_char = sender.char;
			if (_char && _char.id)
			{
				var command:ShowCharViewCommand = new ShowCharViewCommand(_hisName, _char.userId);
				command.execute();

			}
	    }

		public function shop(shopName:String):void
		{
			Global.moduleManager.loadModule(Modules.STUFF_CATALOG, {shop : shopName, countVisible : true});
		}
		
	    public function get location():LocationBase
		{
			 return LocationBase(Global.locationManager.reference.value);
		}
		
		
    }		
}