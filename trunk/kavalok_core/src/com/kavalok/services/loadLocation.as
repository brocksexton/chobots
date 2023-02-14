package com.kavalok.services
{
	public class loadLocation extends Red5ServiceBase
	{
		public function loadLocation(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
	
		public function chknm(val:String) : void
		{	
			doCall("Q", arguments);
		}
		
	}
}