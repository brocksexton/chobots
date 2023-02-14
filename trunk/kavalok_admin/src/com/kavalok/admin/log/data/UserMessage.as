package com.kavalok.admin.log.data
{
	public class UserMessage
	{
		public var login : String;
		public var userId : int;
		public var message : String;
		public var type : String;
		public var buttonName : String;
		public var buttonHandler : Function;
		public var info : String;
		public var height : Number = 40;
		[Bindable]
		public var processed : Boolean = false;
		
		public function UserMessage(login : String, userId : int, message : String, buttonName : String, type : String)
		{
			this.login = login;
			this.userId = userId;
			this.message = message;
			this.buttonName = buttonName;
			this.type = type;
		}
		
		public function process() : void
		{
			processed = true;
		}
		
		

	}
}