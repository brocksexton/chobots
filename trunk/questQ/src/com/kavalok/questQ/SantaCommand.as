package com.kavalok.questQ
{
	import com.kavalok.quest.findItems.NPCCommand;
	import com.kavalok.quest.findItems.QuestStates;
	
	import questQ.McSanta;
	import com.kavalok.Global;

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
			
			if (state == QuestStates.QUEST_TASK)
			{
				dialog.onAccept = startQuest;
			}
			else if (state == QuestStates.NEXT_ITEM)
			{
				
			}
			else if (state == QuestStates.QUEST_COMPLETE)
			{
				dialog.onClose = giveItem;
			
			}
			else if (state == QuestStates.IDLE_MESSAGE)
			{
				var text:String = _santaQuest.bundle.messages[QuestStates.IDLE_MESSAGE];
				_npc.showDialog([text]);
				dialog = null;
			}
			
			if (dialog)
				dialog.execute();
		}
		
		private function giveItem():void
		{
			//finished
			_santaQuest.retriveItem(Quest.ITEM);
			Global.locationManager.location.sendAddBonus(500, "complete questQ");
			Global.charManager.currentQuest = "";
			Global.charManager.satellitesPlaced.length = 0;
			Global.charManager.satellitesMustPlace.length = 0;
			_santaQuest.currentState=0;
		}

		private function startQuest():void
		{
			//starting quest
			Global.charManager.satellitesPlaced.length = 0;
			Global.charManager.currentQuest = "questQ";
			_santaQuest.currentState = 1;
			_santaQuest.setLocations();
		}
		
	}
}