package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.remoting.commands.ServerCommandBase;
	
	public class GoToLoc extends ServerCommandBase
	{
	
	private static var roomList:Array = new Array ("loc0", "loc1", "loc2", "loc3", "loc5", "loc6", "loc7", "loc8", "loc9", "loc10", "loc11", "loc12", "loc13",  "loc32", "locAcademy", "locAcademyRoom", "locAccShop", "locAgents", "locationRope", "locBeach", "locBuilding", "locCafe", "locChlos", "locCinema", "locCircus", "locCitizen", "locColor", "locDisco", "locDudes", "locEco", "locEcoShop", "locFashion", "locForest", "locGames", "locGirls", "locGraphity", "locGraphityA", "locGraphityM", "locHome", "locHomeShop", "locKongregateSweetBattle", "locMagicShop", "locMissions", "locMusic", "locMusicStage", "locNichos", "locNichos1", "locNichos2", "locNichos3", "locNichos4", "locNichos5", "locNichos6", "locNichos7", "locNichos8", "locPark", "locPark_autumn", "locPark_spring", "locParty", "locRobots", "locSanta", "locSecret", "locSpace", "locStaff", "locTesting", "locWinterPark", "missionFarm", "missionNichos","locEmeralds");
	    
		
		public function GoToLoc()
		{
		
		}
		
		override public function execute():void
		{
			var deets:String = String(parameter);
			if(roomList.indexOf(deets, 0) == -1){
			var spl:Array = deets.split(",");
			var obj:Object = new Object();
			obj.charId = spl[0].toString();
			obj.userId = spl[1].valueOf();
			Global.moduleManager.loadModule("home", obj);
			}else{
			 Global.moduleManager.loadModule(deets);
			}
		}
	
	}
}