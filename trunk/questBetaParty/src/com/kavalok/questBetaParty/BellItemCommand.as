package com.kavalok.questBetaParty
{
	import com.kavalok.Global;
	import com.kavalok.char.CharModels;
	import com.kavalok.location.entryPoints.SpriteEntryPoint;
	import com.kavalok.quest.findItems.FindItemsQuestBase;
	import com.kavalok.quest.findItems.QuestItem;
	import com.kavalok.quest.findItems.QuestItemCommand;

	public class BellItemCommand extends QuestItemCommand
	{
		public function BellItemCommand(quest:FindItemsQuestBase, bell:QuestItem)
		{
			super(quest, bell, McBell);
		}
		
		
		override protected function takeItem(sender:SpriteEntryPoint) : void
		{
			super.takeItem(sender);
			Global.charManager.tool = Quest.BELL;
			location.sendUserModel(CharModels.TAKE, -1, Quest.BELL);
		}
	}
}