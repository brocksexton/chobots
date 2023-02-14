package com.kavalok.questAcademy
{
	import com.kavalok.Global;
	import com.kavalok.constants.Locations;
	import com.kavalok.gameplay.commands.RetriveStuffCommand;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	
	public class Quest
	{
		static public const STUFF_ITEM1:String = 'glasses_professor';
		static public const STUFF_ITEM2:String = 'globus';
		static public const NPC_LOCATION:String = Locations.LOC_ACADEMY_ROOM;
		static public const NPC_CONTAINER:String = 'npcContainer';
		static public const CHAR_ZONE:String = 'charZone';
		static public const MONEY:int = 200;
		
		static private var _instance:Quest;
 		
 		private var _bundle:ResourceBundle = Localiztion.getBundle('questAcademy');
		
		public function Quest()
		{
			_instance = this;
			
			if (Global.locationManager.locationExists)
				onLocationChange();
				
			addListeners();
		}
		
		public function addListeners():void
		{
			Global.locationManager.locationChange.addListener(onLocationChange);
		}
		
		public function removeListeners():void
		{
			Global.locationManager.locationChange.removeListener(onLocationChange);
		}
		
		public function retriveItem(itemName:String):void
		{
			var sender:String = bundle.messages.npcName;
			new RetriveStuffCommand(itemName, sender).execute();
		}
		
		private function onLocationChange():void
		{
			var locId:String = Global.locationManager.locationId;
			
			if (locId == NPC_LOCATION && Global.locationManager.isLocationReady)
				Global.locationManager.executeCommand(new NPCCommand());
		}
		
		public function hasItem(itemName:String):Boolean
		{
			return Global.charManager.stuffs.stuffExists(itemName);
		}
		
		public function destroy():void
		{
			removeListeners();
		}
		
		static public function get instance():Quest { return _instance; }
		
		public function get bundle():ResourceBundle { return _bundle; }
	}
}