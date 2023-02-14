package com.kavalok.services
{

	public class LocationInfoService extends Red5ServiceBase
	{
		public function LocationInfoService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		// gh (getHash/LocationInfo);
		public function gh(locId:String):void {
			doCall("gh", arguments);
		}
		
	}
}