package com.kavalok.char
{
	import com.kavalok.dto.friend.FriendTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.messenger.commands.RemoveFriendMessage;
	import com.kavalok.services.CharService;
	import com.kavalok.services.MessageService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	public class Friends
	{
		static public const SUPER_LIMIT:int = 1000;
		static public const REGULAR_LIMIT:int = 150;
		static public const LEVEL_LIMIT:int = 200;
		static public const AGENT_LIMIT:int = 400;
		static public const CITIZEN_LIMIT:int = 2000; //Written as "unlimited"
		
		private var _refreshEvent:EventSender = new EventSender();
		private var _list:Array = [];
		
		public function Friends()
		{
		}
		
		public function addFriend(userId:int):void
		{
			new CharService(onResult).setCharFriend(userId);
		}
		
		public function removeFriends(friendsList:Array):void
		{
			new CharService(onResult).removeCharFriends(friendsList);
			
			for each (var userId:Number in friendsList)
			{
				new MessageService().sendCommand(userId, new RemoveFriendMessage());
			}
		}
		
		public static function upperCase(str:String):String {
			var firstChar:String = str.substr(0, 1);
			var restOfString:String = str.substr(1, str.length);
			
			return firstChar.toUpperCase() + restOfString.toLowerCase();
			
		}	
	
		public function refresh():void
		{
			new CharService(onResult).getCharFriends();
		}
		
		public function contains(charId:String):Boolean
		{
			return Arrays.containsByRequirement(
				_list, new PropertyCompareRequirement('login', charId));
		}
		
		private function onResult(result:Array):void
		{
			var frnd : Array = [];
			for (var i:int = 0; i < result.length; i++)
			{
				var friend:FriendTO = new FriendTO(result[i]);
				frnd.push(friend);
			}
			list = frnd;
		}
		
		public function get length():Number
		{
			 return _list.length;
		}

		public function get list():Array { return _list; }
		
		public function set list(value:Array):void
		{
			 _list = value;
			 _refreshEvent.sendEvent();
		}
		
		public function get refreshEvent():EventSender { return _refreshEvent; }
	}
}