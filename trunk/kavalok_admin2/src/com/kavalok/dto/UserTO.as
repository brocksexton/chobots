package com.kavalok.dto
{
	[RemoteClass(alias="com.kavalok.dto.UserTO")]
	[Bindable]

	public class UserTO extends CharTO
	{


		public var login:String;

		public var server:String;

		public var ip:String;

		public var email:String;

		public var banCount:int;

		public var banDate:Date;

		public var citizenExpirationDate:Date;

		public var citizenStartDate:Date;

		public var locations:String;

		public var activated:Boolean;

		public var agent:Boolean;

		public var moderator:Boolean;

		public var citizen:Boolean;

		public var baned:Boolean;

		public var parent:Boolean;

		public var drawEnabled:Boolean;

		public var banReason:String;

		public var ipBaned:Boolean;

		public var deleted:Boolean;

	}
}

