package com.kavalok.services
{
	public class PaperService extends Red5ServiceBase
	{
		public function PaperService(resultHandler:Function)
		{
			super(resultHandler);
		}
		
		public function getMessagesCount() : void
		{
			doCall("getMessagesCount", arguments);
		}
		
		public function getMessage(index : uint) : void
		{
			doCall("getMessage", arguments);
		}

		public function getTitles(count : uint) : void
		{
			doCall("getTitles", arguments);
		}
		
		public function getMessages(count : uint) : void
		{
			doCall("getMessages", arguments);
		}

	}
}