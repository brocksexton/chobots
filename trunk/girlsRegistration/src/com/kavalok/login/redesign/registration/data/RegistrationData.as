package com.kavalok.login.redesign.registration.data
{
	import com.kavalok.char.CharManager;
	import com.kavalok.dto.login.MarketingInfoTO;
	
	public class RegistrationData
	{
		public var login : String;
		public var password : String;
		public var email : String;
		public var body : String = CharManager.DEFAULT_BODY;
		public var color : int;
		public var isParent : Boolean;
		public var hasEmail : Boolean;
		public var familyMode : Boolean;
		public var locale : String;
		public var invitedBy : String;
		public var marketingInfo : MarketingInfoTO;
        public var gender : String = "boy";
   		public function RegistrationData()
		{
		}

	}
}