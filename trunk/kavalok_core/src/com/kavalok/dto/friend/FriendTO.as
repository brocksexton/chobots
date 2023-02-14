package com.kavalok.dto.friend
{
	import flash.net.registerClassAlias;
	
	public class FriendTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.friend.FriendTO", FriendTO);
		}
		
		public var login:String;
		public var userId:Number;
		public var server:String;
		
		public function FriendTO(stringPresentation : String = null)
		{
			if(stringPresentation==null)
				return;
			var infoArr:Array = stringPresentation.split('|');
			login = infoArr[0]; 
			userId = int(infoArr[1]); 
			server = infoArr[2]; 
			if(server=='')
				server=null;
		}
	}
}

