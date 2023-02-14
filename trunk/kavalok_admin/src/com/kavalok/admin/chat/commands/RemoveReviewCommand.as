package com.kavalok.admin.chat.commands
{
	import com.kavalok.admin.chat.data.WordData;
	import com.kavalok.services.MessageService;

	public class RemoveReviewCommand extends WordCommandBase
	{
		public function RemoveReviewCommand(data:WordData)
		{
			super(data);
		}
		
		override public function execute():void
		{
			wordData.remove();
			new MessageService(onResult, onFault).removeReviewMessage(wordData.item.id);
		}
		
		override protected function onResult(result:Object):void
		{
		}
	}
}