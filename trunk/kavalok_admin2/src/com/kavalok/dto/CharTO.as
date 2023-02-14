package com.kavalok.dto
{
	
	[RemoteClass(alias="com.kavalok.dto.CharTO")]

	public class CharTO
	{

		[Bindable]
		public var userId:int;

		[Bindable]
		public var id:String;

		[Bindable]
		public var body:String;

		[Bindable]
		public var color:Number;

		[Bindable]
		public var chatEnabled:Boolean;

		[Bindable]
		public var chatEnabledByParent:Boolean;

		[Bindable]
		public var chatBanLeftTime:Number;

		[Bindable]
		public var enabled:Boolean;

		[Bindable]
		public var isParent:Boolean;

		[Bindable]
		public var isCitizen:Boolean;

		[Bindable]
		public var guest:Boolean;

		[Bindable]
		public var isAgent:Boolean;

		[Bindable]
		public var isModerator:Boolean;

		[Bindable]
		public var online:Boolean;

		[Bindable]
		public var locale:String;

		[Bindable]
		public var age:Number;

		[Bindable]
		public var acceptRequests:Boolean;

		[Bindable]
		public var clothes:Array


	}
}

