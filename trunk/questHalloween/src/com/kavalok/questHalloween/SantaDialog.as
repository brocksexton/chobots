package com.kavalok.questHalloween
{
	import com.kavalok.quest.findItems.QuestDialogBase;
		import com.kavalok.quest.findItems.FindItemsQuestBase;
	import com.kavalok.quest.findItems.NPCCommand;
	import com.kavalok.quest.findItems.QuestStates;
	import com.kavalok.Global;

		import com.kavalok.utils.Strings;
	
	import McWindow;

	
	public class SantaDialog extends QuestDialogBase
	{
			private var _dialodId:String;
		public function SantaDialog(dialodId:String)
		{
			_dialodId = dialodId;
			super(McWindow, 'questHalloween', dialodId)
		}

		override public function execute():void
		{
			super.execute();
			if(_dialodId == QuestStates.NEXT_ITEM)
			{
				_content.textField.text = Strings.substitute(_bundle.getMessage(_dialodId), Global.batsLeft);
			}
			
		}
		
		
	}
}