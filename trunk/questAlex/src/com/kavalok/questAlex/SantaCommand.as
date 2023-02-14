package com.kavalok.questAlex
{
	import com.kavalok.quest.findItems.NPCCommand;
	import com.kavalok.quest.findItems.QuestStates;
	import com.kavalok.Global;
	
	import questAlex.McSanta;

	public class SantaCommand extends NPCCommand
	{
		private var _santaQuest : Quest;
		public function SantaCommand(quest : Quest)
		{
			_santaQuest = quest;
			super(quest, McSanta);
		}
		
		override protected function onNpcActivate():void
		{
			var state:String = _santaQuest.getState();
			var dialog:SantaDialog = new SantaDialog(state);			
		/*	
			if (state == QuestStates.QUEST_TASK)
			{
				dialog.onAccept = _santaQuest.createItems;
			}
			else if (state == QuestStates.NEXT_ITEM)
			{
				dialog.onClose = _santaQuest.removeItem; 
				location.sendUserTool(null);
			}
			else if (state == QuestStates.QUEST_COMPLETE)
			{
				dialog.onClose = giveItem;
				location.sendUserTool(null);
			}
			else if (state == QuestStates.IDLE_MESSAGE)
			{*/
				var text:String = Global.upperCase(Global.charManager.charId) + "! I managed to escape from them. All the others are still there though. Save them!";
				_npc.showDialog([text]);
				dialog = null;
		//	}
			
		//	if (dialog)
			///	dialog.execute();
		}
		
		private function giveItem():void
		{
		//	_santaQuest.retriveItem(Quest.ITEM);
		}
		
	}
}