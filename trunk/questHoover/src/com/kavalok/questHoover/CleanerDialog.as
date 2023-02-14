package com.kavalok.questHoover
{
	import com.kavalok.quest.findItems.FindItemsQuestBase;
	import com.kavalok.quest.findItems.QuestDialogBase;
	import com.kavalok.quest.findItems.QuestStates;
	import com.kavalok.utils.Strings;
	
	public class CleanerDialog extends QuestDialogBase
	{
		private var _quest : FindItemsQuestBase;
		public function CleanerDialog(quest : FindItemsQuestBase, dialogId : String)
		{
			super(McDialog, "questHoover", dialogId);
			_quest = quest;
		}

		override public function execute():void
		{
			super.execute();
			if(_dialogId == QuestStates.NO_ITEM)
			{
				_content.textField.text = Strings.substitute(_bundle.getMessage(_dialogId), _quest.items.length);
			}
			
		}
	}
}