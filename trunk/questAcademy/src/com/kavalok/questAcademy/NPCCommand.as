package com.kavalok.questAcademy
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
			var npcSprite:McProfessor = new McProfessor();
			var container:Sprite = location.charContainer.getChildByName(Quest.NPC_CONTAINER) as Sprite;
			var zoneSprite:Sprite = container.getChildByName(Quest.CHAR_ZONE) as Sprite;
			
			container.addChild(npcSprite);
			
			_npc = new NPCChar(npcSprite, zoneSprite, location);
			_npc.activateEvent.addListener(processNPC);
		}
		
		private function processNPC():void
		{
			if (Global.charManager.isGuest)
				new RegisterGuestCommand().execute();
			else
				new NPCDialog().execute();
		}
		
		protected function get quest():Quest
		{
			 return Quest.instance;
		}
	}
}