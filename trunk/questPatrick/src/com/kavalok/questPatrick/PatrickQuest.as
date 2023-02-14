package com.kavalok.questPatrick
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

	public class PatrickQuest extends FindItemsQuestBase
	{
		public static const POT : String = "Cleaner_pot";
//		public static const PYLESOS : String = "Cleaner_pylesos";
//		public static const KASKA : String = "Cleaner_kaska";
		public static const SHOES : String = "Cleaner_board";

 		private var _bundle:ResourceBundle = Localiztion.getBundle('questPatrick');
		
		private var _complete : Boolean;
		
		public function PatrickQuest()
		{
			super(Locations.LOC_1, null, 10, "questPatrick");
		}
		
		override public function getState():String
		{
			if (hasItem(SHOES))
				return QuestStates.IDLE_MESSAGE;
				
			if (_complete)
				return QuestStates.QUEST_COMPLETE;	
			
			if (_items.length > 0)	
				return QuestStates.NO_ITEM;
				
			if (hasItem(POT))
				return QuestStates.QUEST_TASK;
				
			return QuestStates.FIRST_ITEM;
		}

		override public function removeItem():void
		{
			super.removeItem();
			Global.locationManager.location.sendAddBonus(20, "PATRICK");
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