package com.kavalok.services
{

	public class MagicServiceNT extends Red5ServiceBase
	{
		public function MagicServiceNT(resultHandler:Function = null, faultHandler:Function = null)
		{
			super(resultHandler, faultHandler);
		}

		public function getMagicPeriod():void
		{
			doCall("getMagicPeriod", arguments);
		}
		
		public function getLastVisit():void
		{
			doCall("getLastVisit", arguments);
		}
		
		public function setLastVisit():void
		{
			doCall("setLastVisit", arguments);
		}

		public function getLastDaily():void
		{
			doCall("getLastDaily", arguments);
		}

		public function setLastDaily():void
		{
			doCall("setLastDaily", arguments);
		}
		public function updateMagicDate():void
		{
			doCall("updateMagicDate", arguments);
		}
	}
}