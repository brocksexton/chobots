package com.kavalok.quest.findItems
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.location.commands.LocationCommandBase;
	import com.kavalok.location.npc.NPCChar;
	
	import flash.display.Sprite;

	public class NPCCommand extends LocationCommandBase
	{
		static public const NPC_CONTAINER:String = 'npcContainer';
		static public const CHAR_ZONE:String = 'charZone';

		protected var _npc:NPCChar;
		private var _npcSpriteClass:Class;
		protected var _quest : FindItemsQuestBase;
		
		public function NPCCommand(quest : FindItemsQuestBase, npcSpriteClass : Class)
		{
			super();
			_quest = quest;
			_npcSpriteClass = npcSpriteClass;
		}
		
		override public function execute():void
		{
			var npcSprite:Sprite = new _npcSpriteClass();
			var container:Sprite = location.charContainer.getChildByName(NPC_CONTAINER) as Sprite;
			var zoneSprite:Sprite = container.getChildByName(CHAR_ZONE) as Sprite;
			
			container.addChild(npcSprite);
			
			_npc = new NPCChar(npcSprite, zoneSprite, location);
			_npc.activateEvent.addListener(checkGuest);
		}
		
		private function checkGuest():void
		{
			if (Global.charManager.isGuest)
				new RegisterGuestCommand().execute();
			else
				onNpcActivate();
		}
		
		protected function onNpcActivate() : void
		{
		}
		
	}
}