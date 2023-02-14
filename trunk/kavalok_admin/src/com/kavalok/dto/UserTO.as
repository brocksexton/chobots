package com.kavalok.dto
{
	[RemoteClass(alias="com.kavalok.dto.UserTO")]
	[Bindable]

	public class UserTO extends CharTO
	{


		public var login:String;
		
		public var blogLink:String;

		public var server:String;

		public var ip:String;

		public var prevLogin:Date;

		public var email:String;

		public var banCount:int;

		public var banDate:Date;

		public var timeBan:Date;

		public var citizenExpirationDate:Date;

		public var citizenStartDate:Date;

		public var locations:String;

		public var status:String;
		
		public var activated:Boolean;

		public var agent:Boolean;

		public var merchant:Boolean;

		public var resetPass:Boolean;

		public var defaultFrame:Boolean;
		
		public var exp:int;

		public var uiCol:int;
		
		public var lvl:int;
		
		public var ninja:Boolean;

		public var moderator:Boolean;

		public var forumer:Boolean;
		
		public var staff:Boolean;
		
		public var des:Boolean;
		
		public var dev:Boolean;
		
		public var support:Boolean;

		public var citizen:Boolean;

		public var scout:Boolean;
		
		public var blog:String;

		public var baned:Boolean;

		public var parent:Boolean;

		public var drawEnabled:Boolean;
		
		public var blogURL:String;

		public var banReason:String;
		
		public var charInfo:String;

		public var ipBaned:Boolean;

		public var deleted:Boolean;
		
		public var artist:Boolean;
		
		public var journalist:Boolean;

		public var UIColour:String;

		public var team:String;
		

	}
}

