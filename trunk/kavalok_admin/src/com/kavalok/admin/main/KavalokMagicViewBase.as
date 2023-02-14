package com.kavalok.admin.main
{
	import com.kavalok.services.LoginService;
	
	public class KavalokMagicViewBase extends MainViewBase
	{
		public function KavalokMagicViewBase()
		{
			super();
		}
		
		override public function tryLogin(login : String, pass : String) : void
		{
			new LoginService(onLoginResult, onLoginFault).jakeLogin(login, pass);
		}
	}
}