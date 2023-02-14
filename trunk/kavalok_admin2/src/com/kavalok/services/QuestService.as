package com.kavalok.services
{
	import com.kavalok.dto.admin.QuestTO;
	
	public class QuestService extends Red5ServiceBase
	{
		public function QuestService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getQuests() : void 
		{
			doCall("getQuests", arguments);
		}
		
		public function saveQuest(data:QuestTO):void
		{
			doCall("saveQuest", arguments);
		}	
		
	}
}