package com.kavalok.admin.quest
{
	import com.kavalok.admin.users.data.ServersDataProvider;
	import com.kavalok.dto.admin.QuestTO;
	import com.kavalok.services.QuestService;
	
	import mx.collections.ArrayList;
	import mx.containers.VBox;
	import mx.controls.Button;

	public class QuestBase extends VBox
	{
		[Bindable]
		public var quests:ArrayList = new ArrayList();
		
		[Bindable]
		public var serversDataProvider:ServersDataProvider = new ServersDataProvider();
		
		public function QuestBase()
		{
			super();
			refresh();
		}
		
		public function setQuestEnabled(data:Object, button:Button):void
		{
			data.enabled = !data.enabled;
			button.visible = false;
			new QuestService().saveQuest(QuestTO(data));
			refresh();
		}
		
		public function getServerIndex(serverId:int):int
		{
			return serversDataProvider.getIndexById(serverId);
		}
		
		public function refresh():void
		{
			new QuestService(onGetData).getQuests();
		}
		
		private function onGetData(result:Array):void
		{
			quests = new ArrayList(result);
		}
		
	}
}