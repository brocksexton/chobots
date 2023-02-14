package com.kavalok.questQ
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.constants.Locations;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.quest.findItems.FindItemsQuestBase;
	import com.kavalok.quest.findItems.NPCCommand;
	import com.kavalok.quest.findItems.QuestItem;
	import com.kavalok.quest.findItems.QuestItemCommand;
	import com.kavalok.quest.findItems.QuestStates;
	
	import questQ.McBell;
	
	public class Quest extends FindItemsQuestBase
	{
		static public const ITEM:String = 'bicycle_One_wheel';
		
		static public const NUM_BELLS:int = 8;
		static public const SANTA_LOCATION:String = Locations.LOC_HOMESHOP;
		
		static public const BELL:String = 'candy';
		public var currentState:int = 0;
 		
		
 		private var _bundle:ResourceBundle = Localiztion.getBundle('questQ');
		
		public function Quest()
		{
			super(SANTA_LOCATION, McBell, NUM_BELLS, "questQ");
			/*
			* preload tool resource
			*/
			new ResourceSprite(URLHelper.charToolURL(Quest.BELL), 'McTool', true, false);
		}
		
		
		override protected function createNPCCommand():NPCCommand
		{
			return new SantaCommand(this);
		}
		override protected function createItemCommand(item:QuestItem):QuestItemCommand
		{
			return new BellItemCommand(this, item);
		}
		
		public function setLocations():void
		{
			var arr1:Array = ["loc1", 
							  "loc2", 
							  "locCafe", 
							  "loc5", 
							  "locEcoShop", 
							  "locAcademy", 
							  "locAcademyRoom",
							  "locGraphity",
							  "locGames",
							  "locPark",
							  "locMusic",
							  "locRobots",
							  "locMissions",
							  "locMagicShop",
							  "locAccShop",
							  "locEco",
							  "loc0"];
			ShuffleArray(arr1);
			Global.charManager.satellitesMustPlace.push(arr1[0], arr1[1], arr1[2], arr1[3], arr1[4]);
			if(Global.charManager.isModerator)
			trace("Must place at: " + Global.charManager.satellitesMustPlace);

 		}

 		public function ShuffleArray(input:Array):void
		{
			for (var i:int = input.length-1; i >=0; i--)
			{
				var randomIndex:int = Math.floor(Math.random()*(i+1));
				var itemAtIndex:Object = input[randomIndex];
				input[randomIndex] = input[i];
				input[i] = itemAtIndex;
			}
		}

		override public function get canTake():Boolean
		{
			return (Global.charManager.tool == BELL);
		}
		
		override public function getState():String
		{
			if (hasItem(ITEM))
				return QuestStates.IDLE_MESSAGE;
				
			if ((Global.charManager.satellitesMustPlace.length == 0) && (currentState == 1))
				return QuestStates.QUEST_COMPLETE;	
			
			if ((Global.charManager.satellitesMustPlace.length < 5) && (currentState == 1))
				return QuestStates.NEXT_ITEM;
				
			if (Global.charManager.satellitesMustPlace.length == 5)	
				return QuestStates.NO_ITEM;

				
			return QuestStates.QUEST_TASK;
		}

		public function get batsLeft():int
		{
			return _items.length;
		}
		
		public function get bundle():ResourceBundle { return _bundle; }
	}
}