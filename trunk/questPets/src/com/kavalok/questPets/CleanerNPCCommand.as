package com.kavalok.questPets
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.quest.findItems.FindItemsQuestBase;
	import com.kavalok.quest.findItems.NPCCommand;
	import com.kavalok.quest.findItems.QuestStates;

	public class CleanerNPCCommand extends NPCCommand
	{
		private static var _bundle : ResourceBundle = Localiztion.getBundle("questPets");
		
		public function CleanerNPCCommand(quest:FindItemsQuestBase)
		{
			super(quest, McCleaner);
		}
		
		override protected function onNpcActivate():void
		{
			var state:String = _quest.getState();
			var dialog:CleanerDialog = new CleanerDialog(_quest, state);			
			
			if (state == QuestStates.FIRST_ITEM)
			{
				dialog.onClose = giveFirstItem;
			}
			else if (state == QuestStates.QUEST_TASK)
			{
				dialog.onAccept = _quest.createItems;
			}
			else if (state == QuestStates.NEXT_ITEM)
			{
				dialog.onClose = _quest.removeItem; 
				location.sendUserTool(null);
			}
			else if (state == QuestStates.QUEST_COMPLETE)
			{
				dialog.onClose = giveSecondItems;
			}
			else if (state == QuestStates.QUEST_PETS)
			{
				dialog.onClose = loadPetConstructor;
			}
			else if (state == QuestStates.IDLE_MESSAGE)
			{
				var text:String = _bundle.getMessage(QuestStates.IDLE_MESSAGE);
				_npc.showDialog([text]);
				dialog = null;
			}
			
			if (dialog)
				dialog.execute();
		}

		private function giveSecondItems():void
		{
			_quest.retriveItem(HooverQuest.SHOES);
		    Global.moduleManager.loadModule(Modules.PETS);
		}
		
		private function loadPetConstructor():void
		{
		    Global.moduleManager.loadModule(Modules.PETS);
		}
		private function giveFirstItem():void
		{
			_quest.retriveItem(HooverQuest.PYLESOS);
		}
		
	}
}