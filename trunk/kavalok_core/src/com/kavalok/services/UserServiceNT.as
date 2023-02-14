package com.kavalok.services
{
	public class UserServiceNT extends Red5ServiceBase
	{
		public function UserServiceNT(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function userExists(login : String) : void
		{
			doCall("userExists", arguments);
		}
		
		public function blockUserChat(email : String) : void
		{
			doCall("blockUserChat", arguments);
		}

		public function setHelpEnabled(value : Boolean) : void
		{
			doCall("setHelpEnabled", arguments);
		}

		public function setLocale(value : String) : void
		{
			doCall("setLocale", arguments);
		}
		
		public function tryCitizenship() : void
		{
			doCall("tryCitizenship", arguments);
		}

		public function daysCanTryCitizenship() : void
		{
			doCall("daysCanTryCitizenship", arguments);
		}
		
	}
}