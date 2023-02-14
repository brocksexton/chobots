package com.kavalok.services
{

	public class LocationService extends Red5ServiceBase
	{
		public function LocationService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function moveTO(sharedObjectId : String, x : int, y : int, petBusy : Boolean) : void {
			doCall("moveTO", arguments);
		}
		
	}
}