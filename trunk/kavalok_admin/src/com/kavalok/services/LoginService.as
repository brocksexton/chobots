package com.kavalok.services
{
		import com.kavalok.dto.login.MarketingInfoTO;
	import com.kavalok.remoting.BaseRed5Delegate;

 // console
	
	public class LoginService extends BaseRed5Delegate
	{
		public function LoginService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}

	public function tretreAdminlol(name : String, password : String) : void 
		{
			doCall("lgAmn30", arguments);
		}

			public function activateAccount(login:String, activationKey:String, chatEnabled:Boolean):void
		{
			doCall("activateAccount", arguments);
		}
		
		public function getServerProperties():void
		{
			doCall("getServerProperties", arguments);
		}
		
		public function sendPassword(email:String, locale:String):void
		{
			doCall("sendPassword",  arguments);
		}
		
		public function getActivationInfo(login:String):void
		{
			doCall("getActivationInfo",  arguments);
		}
		
		public function sendActivationMail(host: String, login:String, locale:String):void
		{
			doCall("sendActivationMail", arguments);
		}
		
		

			public function adminLogin(name : String, password : String) : void 
		{
			doCall("adminLogin", arguments);
		}
		
		public function partnerLogin(name : String, password : String) : void 
		{
			doCall("partnerLogin", arguments);
		}
		
		public function jakeLogin(name : String, password : String) : void
		{
			doCall("jakeLogin", arguments);
		}
		
			public function magicLogin(name : String, password : String) : void 
			{
				doCall("magicLogin", arguments);
			}
		
		public function guestLogin(marketinginfo : MarketingInfoTO) : void 
		{
			doCall("guestLogin", arguments);
			// instead of actually logging in with guest access, just stop
		}
		
		public function freeLoginByPrefix(prefix: String) : void
		{
			doCall("freeLoginByPrefix", arguments);
		} 
		
		public function freeLogin(name : String, body:String, color:int, locale : String, password:String) : void 
		{
			doCall("freeLogin", arguments);
		}
		
		public function login(login : String, passw : String, locale : String) : void 
		{
			doCall("loginmay09", arguments);
		}
		
		public function getPartnerLoginInfo(uid : String) : void
		{
			doCall("getPartnerLoginInfo", arguments);
		}
		
		public function registerFromPartner(uid:String, body:String, color:int, isParent:Boolean, gender:String) : void
		{
			doCall("registerFromPartner", arguments);
		}
		
		public function register(login:String, passw:String, email:String,
			body:String, color:int, isParent:Boolean, familyMode:Boolean, locale : String,
			invitedBy : String,	marketingInfo : MarketingInfoTO, gender : String):void
		{
			doCall("register", arguments);
		}

		public function registerGirls(login:String, passw:String, email:String,
			body:String, color:int, isParent:Boolean, familyMode:Boolean, locale : String,
			invitedBy : String,	marketingInfo : MarketingInfoTO, gender : String):void
		{
			doCall("registerGirls", arguments);
		}

		public function getMostLoadedServer(locId : String) : void
		{
			doCall("getMostLoadedServer", arguments);
		}
		
	}
}