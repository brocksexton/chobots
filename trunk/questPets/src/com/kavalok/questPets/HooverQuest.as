package com.kavalok.questPets
{
	import com.kavalok.Global;
	import com.kavalok.constants.Locations;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.quest.findItems.FindItemsQuestBase;
	import com.kavalok.quest.findItems.NPCCommand;
	import com.kavalok.quest.findItems.QuestItem;
	import com.kavalok.quest.findItems.QuestItemCommand;
	import com.kavalok.quest.findItems.QuestStates;

	public class HooverQuest extends FindItemsQuestBase
	{
		public static const PYLESOS : String = "handbag";
//		public static const KASKA : String = "Cleaner_kaska";
		public static const SHOES : String = "lemonade";

 		private var _bundle:ResourceBundle = Localiztion.getBundle('questPets');
		
		private var _complete : Boolean;
		
		public function HooverQuest()
		{
			super(Locations.LOC_CHLOS, null, 10, "questPets");
		}
		
		override public function getState():String
		{
			if (hasItem(SHOES))
				return QuestStates.QUEST_PETS;
				
			if (_complete)
				return QuestStates.QUEST_COMPLETE;	
			
			if (_items.length > 0)	
				return QuestStates.NO_ITEM;
				
			if (hasItem(PYLESOS))
				return QuestStates.QUEST_TASK;
				
			return QuestStates.FIRST_ITEM;
		}

		override public function removeItem():void
		{
			super.removeItem();
			Global.locationManager.location.sendAddBonus(50, "pets quest");
			if(_items.length == 0)
				_complete = true;
			Global.playSound(SoundHoover);
		}
		override protected function createItemCommand(item : QuestItem) : QuestItemCommand
		{
			return new GarbageItemCommand(this, item);
		}

		override protected function createNPCCommand():NPCCommand
		{
			return new CleanerNPCCommand(this);
		}
		
	}
}