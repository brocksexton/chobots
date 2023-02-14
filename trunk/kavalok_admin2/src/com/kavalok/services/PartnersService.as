package com.kavalok.services
{
	public class PartnersService extends Red5ServiceBase
	{
		public function PartnersService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getUsersByDates(from : Date, to : Date, firstResult : int, maxResults : int) : void 
		{
			doCall("getUsersByDates", arguments);
		}
		public function getUsers(firstResult : int, maxResults : int) : void
		{
			doCall("getUsers", arguments);
		}
		
		
	}
}