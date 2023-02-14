package com.kavalok.admin.main
{
	import com.kavalok.services.LoginService;
	
	public class PartnersViewBase extends MainViewBase
	{
		public function PartnersViewBase()
		{
			super();
		}
		
		override public function tryLogin(login : String, pass : String) : void
		{
			new LoginService(onLoginResult, onLoginFault).partnerLogin(login, pass);
		}
	}
}