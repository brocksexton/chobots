package com.kavalok.dto.stuff
{
	
	[RemoteClass(alias="com.kavalok.dto.stuff.StuffTypeAdminTO")]
	
	public class StuffTypeAdminTO
	{
		[Bindable] public var id:int;
		[Bindable] public var fileName:String;
		[Bindable] public var name:String;
		[Bindable] public var hasColor:Boolean;
		[Bindable] public var premium:Boolean;
		[Bindable] public var giftable:Boolean;
		[Bindable] public var rainable:Boolean;
		[Bindable] public var price:int;
		[Bindable] public var shopName:String;
		[Bindable] public var type:String;
		[Bindable] public var placement:String;
		[Bindable] public var info:String;
		[Bindable] public var itemOfTheMonth:String;
		[Bindable] public var groupNum:int;
	}
	
}