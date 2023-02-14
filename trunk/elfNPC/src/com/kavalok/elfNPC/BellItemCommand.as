package com.kavalok.elfNPC
{
	import com.kavalok.Global;
	import com.kavalok.char.CharModels;
	import com.kavalok.location.entryPoints.SpriteEntryPoint;
	import com.kavalok.quest.findItems.FindItemsQuestBase;
	import com.kavalok.quest.findItems.QuestItem;
	import com.kavalok.quest.findItems.QuestItemCommand;
	
	import elfNPC.McGift;

	public class BellItemCommand extends QuestItemCommand
	{
		public function BellItemCommand(quest:FindItemsQuestBase, gift:QuestItem)
		{
			super(quest, gift, McGift);
		}
		
		
		override protected function takeItem(sender:SpriteEntryPoint) : void
		{
			super.takeItem(sender);
			Global.charManager.tool = Quest.GIFT;
			location.sendUserModel(CharModels.TAKE, -1, Quest.GIFT);
		}
	}
}