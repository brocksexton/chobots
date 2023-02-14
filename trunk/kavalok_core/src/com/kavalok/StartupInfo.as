package com.kavalok
{
	import com.kavalok.dto.login.MarketingInfoTO;
	
	public class StartupInfo
	{
		public var secure:String;
		public var url:String;
		public var prefix:String = null;
		public var hash:String;
		public var login:String;
		public var server:String;
		public var password:String;
		public var moduleId:String;
		public var moduleParams:Object;
		public var isBot:Boolean = false;
		public var debugMode:Boolean = false;
		public var locale:String;
		public var errorLogEnabled:Boolean = true;
		public var widget:String = null;
		public var partnerUid:String;
		public var homeURL:String;
		public var version:String;
		public var isTesting:String;
		
		public var disableQualityAuto:Boolean;
		
		public var mppc_src:String;
		public var mppc_cid:String;
		public var mppc_keywords:String;
		public var mppc_referrer:String;
		public var mppc_activationUrl:String
		public var mppc_partner:String;
		
		public function get redirectURL():String
		{
			return homeURL || mppc_activationUrl || url;
		}
		
		public function get marketingInfo():MarketingInfoTO
		{
			var result:MarketingInfoTO = new MarketingInfoTO();
			
			result.source = Global.startupInfo.mppc_src;
			result.campaign = Global.startupInfo.mppc_cid;
			result.keywords = Global.startupInfo.mppc_keywords;
			result.referrer = Global.startupInfo.mppc_referrer;
			result.activationUrl = redirectURL;
			result.partner = Global.startupInfo.mppc_partner;
			return result;
		}
	
	}
}