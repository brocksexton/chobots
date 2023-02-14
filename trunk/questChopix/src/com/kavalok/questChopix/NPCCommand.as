package com.kavalok.questChopix
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.location.commands.LocationCommandBase;
	import com.kavalok.location.npc.NPCChar;
	
	import flash.display.Sprite;

	public class NPCCommand extends LocationCommandBase
	{
		private var _npc:NPCChar;
		
		public function NPCCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			createNPC();
		}
		
		private function createNPC():void
		{
			var npcSprite:McChopix = new McChopix();
			var container:Sprite = location.charContainer.getChildByName(Quest.NPC_CONTAINER) as Sprite;
			var zoneSprite:Sprite = container.getChildByName(Quest.CHAR_ZONE) as Sprite;
			
			container.addChild(npcSprite);
			
			_npc = new NPCChar(npcSprite, zoneSprite, location);
			_npc.activateEvent.addListener(processNPC);
		}
		
		private function processNPC():void
		{
			if (Global.charManager.isGuest)
			{
				new RegisterGuestCommand().execute();
				return;
			}
			
			var dialog:NPCDialog = new NPCDialog(quest.state);			
			
			if (quest.state == QuestStates.INITIAL)
			{
				dialog.onClose = quest.retriveItem;				
			}
			else if (quest.state == QuestStates.HAS_ITEM)
			{
				dialog.onAccept = quest.initTarget;
			}
			else if (quest.state == QuestStates.HAS_TASK)
			{
			}
			else if (quest.state == QuestStates.HAS_TARGET
				  || quest.state == QuestStates.HAS_LAST_TARGET)
			{
				location.sendUserTool(null);
				dialog.onClose = quest.completeTarget;
			}
			else if (quest.state == QuestStates.QUEST_COMPLETE)
			{
				var text:String = quest.bundle.messages[QuestStates.QUEST_COMPLETE];
				_npc.showDialog([text]);
				dialog = null;
			}
			
			if (dialog)
				dialog.execute();
		}
		
		protected function get quest():Quest
		{
			 return Quest.instance;
		}
	}
}