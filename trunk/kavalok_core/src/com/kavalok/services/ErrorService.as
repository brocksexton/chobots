package com.kavalok.services
{
	public class ErrorService extends Red5ServiceBase
	{
		public function ErrorService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getErrors(firstResult : int, maxResults : int) : void
		{
			doCall("getErrors", arguments);
		}
		
		public function addError(message : String) : void
		{
			doCall("addError", arguments);
		}
		
		
	}
}