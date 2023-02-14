package com.kavalok.questAlex
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

	import questAlex.McBell;
	
	public class Quest extends FindItemsQuestBase
	{
		static public const ITEM:String = 'hair_guitarhero';
		
		static public const NUM_BELLS:int = 1;
		static public const SANTA_LOCATION:String = Locations.MISSION_FARM;
		
		static public const BELL:String = 'teleport';
 		
		
 		private var _bundle:ResourceBundle = Localiztion.getBundle('questAlex');
		
		public function Quest()
		{
			super(SANTA_LOCATION, McBell, NUM_BELLS, "questAlex");
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
		

		override public function get canTake():Boolean
		{
			return (Global.charManager.tool == BELL);
		}
		
		override public function getState():String
		{
			if (hasItem(ITEM))
				return QuestStates.IDLE_MESSAGE;
				
			if (canTake && _items.length == 1)
				return QuestStates.QUEST_COMPLETE;	
			
			if (canTake)
				return QuestStates.NEXT_ITEM;
				
			if (_items.length > 0)	
				return QuestStates.NO_ITEM;
				
			return QuestStates.QUEST_TASK;
		}
		
		public function get bundle():ResourceBundle { return _bundle; }
	}
}