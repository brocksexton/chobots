package com.kavalok.commands.location
{
	import com.kavalok.Global;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.commands.CitizenWarningCommand;
	import com.kavalok.gameplay.commands.AgentWarningCommand;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.commands.RetriveStuffByIdCommand;
	import com.kavalok.utils.Maths;
	import com.kavalok.interfaces.ICommand;
	import com.kavalok.services.SOService;
		import com.kavalok.services.AdminService;
		import com.kavalok.gameplay.windows.CharWindowView;
	
	public class GotoLocationCommand implements ICommand
	{
		private var _locationId:String
		private var _parameters:Object;
		private var _server:String;
		
		private var _completeEvent:EventSender = new EventSender();
		
		public function GotoLocationCommand(locationId:String, parameters:Object = null, server:String = "")
		{
			_locationId = locationId;
			_parameters = parameters;
			_server = server;
		}
		
		public function execute():void
		{
			if	((_locationId == "locCitizen" || _locationId == "locMusicStage" || _locationId == "loc6" || _locationId == "locCircus" || _locationId == "loc7" || _locationId == "locChlos") && !Global.charManager.isCitizen)
			{
					new CitizenWarningCommand('locationForCitizensOnly', Global.messages.locationForCitizensOnly).execute();
		
			}
			else if (_locationId == "locAgents" && (!Global.charManager.isAgent))
			{
				if (Global.charManager.isModerator)
				loadLocation();
				else
				Dialogs.showOkDialog("This location can only be accessed by agents!", true);
			}
			//else if (_locationId == "locChlos" && !hasItem("teleporter"))
			//{
		//		Dialogs.showOkDialog("You cannot enter the location without the teleporter.")
		//	}
			else if (_locationId == "locCircus" && Global.charManager.isCitizen)
			{
				loadLocation();
				new RetriveStuffByIdCommand(1772, 'Chobots Team', Maths.random(0xffffff)).execute();
			}
			else if (_locationId == "locGirls" && Global.charManager.gender != "girl")
			{
				Dialogs.showOkDialog("Stop right there. This location is for girls only, silly!");
			}
			else if (_locationId == "locDudes" && Global.charManager.gender != "boy")
			{
				Dialogs.showOkDialog("Girl, no. This chill zone is for dudes only!");
			}
		/*	else if (_locationId == "loc3")
			{
				Dialogs.showOkDialog("The snow is being plowed from Cafe Street! Construction workers say you need to wait a few days before you can come here again.");
				Global.moduleManager.loadModule("locPark")
			}*/
			else if (_locationId == "bank")
			{
				Dialogs.showBankDialog(Global.charManager.charId + "'s Bank Account");
			}
			else if (_locationId == "locEmeralds" && !Global.charManager.isMerchant)
			{
				Dialogs.showOkDialog("This location is for people who have bought Emeralds only!");
			}
			else if (Global.charManager.isAgent || Global.charManager.isModerator || Global.superUser || !_locationId)
			{
				loadLocation();
			}
			else
			{
				Global.isLocked = true;
				new SOService(onGetData).getNumConnectedChars(_locationId, _server);
			}
		}
		
		public function onGetData(result:int):void
		{
			Global.isLocked = false;
			if (result >= KavalokConstants.LOCATION_LIMIT && !Global.charManager.isCitizen)
				new CitizenWarningCommand('locationFull', Global.messages.locationFull).execute();
			else
				loadLocation();
		}
		
		protected function hasItem(item:String):Boolean
		{
			return Global.charManager.stuffs.stuffExists(item);
		}
		
		private function loadLocation():void
		{
			if (_server.length > 0 && _server != Global.loginManager.server)
				Global.loginManager.changeServer(_server, _locationId, _parameters);
			else
				Global.moduleManager.loadModule(_locationId, _parameters);
			
			_completeEvent.sendEvent();
			trace("goingto: " + _locationId + ", " + _parameters);
		}
		
		public function get completeEvent():EventSender
		{
			return _completeEvent;
		}
	
	}
}