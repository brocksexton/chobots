package com.kavalok.questCupid22
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
	
	import questCupid22.McBell;
	
	public class Quest extends FindItemsQuestBase
	{
		static public const ITEM:String = 'shirt_tux';
		
		static public const NUM_BELLS:int = 2;
		static public const SANTA_LOCATION:String = Locations.LOC_2;
		
		static public const BELL:String = 'glue';
 		
		
 	//	private var _bundle:ResourceBundle = Localiztion.getBundle('questSanta2010');
		private var _bundle:ResourceBundle = Localiztion.getBundle('questCupid22');
		
		public function Quest()
		{
			//super(SANTA_LOCATION, McBell, NUM_BELLS, "questSanta2010");
			super(SANTA_LOCATION, McBell, NUM_BELLS, "questCupid22");
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