package com.kavalok.questChopix
{
	import com.kavalok.Global;
	import com.kavalok.constants.Locations;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.commands.RetriveStuffCommand;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.Arrays;
	
	public class Quest
	{
		static public const STUFF_ITEM:String = 'okuliari_Chopix';
		static public const TARGETS_MAX:int = 5;
		static public const TARGET_DISTANCE_ACTIVATE:int = 250;
		static public const TARGET_DISTANCE_DEACTIVATE:int = 30;
		static public const TARGET_TOOL:String = 'nichosSpy';
		static public const NPC_LOCATION:String = Locations.LOC_PARK;
		static public const NPC_CONTAINER:String = 'npcContainer';
		static public const CHAR_ZONE:String = 'charZone';
		static public const MONEY_TARGET:int = 50;
		static public const MONEY_COMPLETE:int = 500;
		
 		static public const LOCATIONS:Array =
 		[
	 		Locations.LOC_0,
	 		Locations.LOC_1,
	 		Locations.LOC_2,
	 		Locations.LOC_3,
	 		Locations.LOC_5,
	 		Locations.LOC_ROPE,
	 		Locations.LOC_PARK,
	 		Locations.LOC_GRAPHITY,
	 		Locations.LOC_GRAPHITY_A,
	 		Locations.LOC_ECO,
		]
		
		static private var _instance:Quest;
		
 		
 		private var _bundle:ResourceBundle = Localiztion.getBundle('questChopix');
 		private var _targetsCount:int = 0;
 		private var _targetLocation:String;
		private var _state:String;
		
		public function Quest()
		{
			_instance = this;
			
			if (Global.locationManager.locationExists)
				onLocationChange();
				
			addListeners();
		}
		
		public function get state():String
		{
			if (_targetsCount == TARGETS_MAX)
			{
				return QuestStates.QUEST_COMPLETE;
			}
			if (hasTarget)
			{
				return (_targetsCount == TARGETS_MAX - 1)
					? QuestStates.HAS_LAST_TARGET
					: QuestStates.HAS_TARGET;
			}
			if (_targetLocation)
			{
				return QuestStates.HAS_TASK;
			}
			if (hasItem)
			{
				return QuestStates.HAS_ITEM;
			}
			
			return QuestStates.INITIAL;
		}
		
		public function addListeners():void
		{
			Global.locationManager.locationChange.addListener(onLocationChange);
		}
		
		public function removeListeners():void
		{
			Global.locationManager.locationChange.removeListener(onLocationChange);
		}
		
		public function retriveItem():void
		{
			var sender:String = bundle.messages.npcName;
			new RetriveStuffCommand(STUFF_ITEM, sender).execute();
			_state = QuestStates.HAS_ITEM;
		}
		
		public function initTarget():void
		{
			_targetLocation = Arrays.randomItem(LOCATIONS);
			//_targetLocation = Locations.LOC_PARK;
			onLocationChange();
			trace(_targetLocation);
		}
		
		public function completeTarget():void
		{
			_targetsCount++;
			
			if (_targetsCount < TARGETS_MAX)
			{
				initTarget();
				new AddMoneyCommand(MONEY_TARGET, "questChopix", true).execute();
			}
			else
			{
				_targetLocation = null;
				new AddMoneyCommand(MONEY_COMPLETE, "questChopix", true).execute();
				Global.sendAchievement("ac14;","Chopix");
				Global.addExperience(3);
			}
		}
		
		private function onLocationChange():void
		{
			var locId:String = Global.locationManager.locationId;
			
			if (locId == NPC_LOCATION)
				Global.locationManager.executeCommand(new NPCCommand());
			
			if (locId == _targetLocation && withItem && !hasTarget)
				Global.locationManager.executeCommand(new TargetCommand());
		}
		
		public function get hasTarget():Boolean
		{
			return (Global.charManager.tool == TARGET_TOOL);
		}
		
		public function get withItem():Boolean
		{
			 return Global.charManager.stuffs.isItemUsed(STUFF_ITEM);
		}
		
		private function get hasItem():Boolean
		{
			return Global.charManager.stuffs.stuffExists(STUFF_ITEM);
		}
		
		public function destroy():void
		{
			removeListeners();
		}
		
		public function set targetLocation(value:String):void
		{
			 _targetLocation = value;
		}
		
		static public function get instance():Quest { return _instance; }
		
		public function get bundle():ResourceBundle { return _bundle; }
	}
}