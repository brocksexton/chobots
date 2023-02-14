package com.kavalok.char
{
	import com.kavalok.Global;
	import com.kavalok.dto.friend.FriendTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.robots.RobotConstants;
	import com.kavalok.services.CharService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	public class RobotTeam
	{
		private var _refreshEvent:EventSender = new EventSender();
		private var _list:Array = [];
		private var _owner:String;
		private var _color:int;
		
		public function RobotTeam()
		{
		}
		
		public function get isMine():Boolean
		{
			return _owner == Global.charManager.charId;
		}
		
		public function get isFreeSpace():Boolean
		{
			 return _list.length < RobotConstants.TEAM_LIMIT;
		}
		
		public function refresh():void
		{
			new CharService(onResult).getRobotTeam();
		}
		
		public function contains(charId:String):Boolean
		{
			return Arrays.containsByRequirement(
				_list, new PropertyCompareRequirement('login', charId));
		}
		
		private function onResult(result:Array):void
		{
			list = result;
		}
		
		public function get length():Number
		{
			 return _list.length;
		}
		
		public function get teamExists():Boolean
		{
			 return _list.length > 0;
		}
		
		public function get color():int { return _color; }
		public function set color(value:int):void
		{
			 _color = value;
		}
		
		public function get list():Array { return _list; }
		public function set list(value:Array):void
		{
			 _list = value;
			 _owner = (_list.length > 0) ? FriendTO(_list[0]).login : null;  
			 _refreshEvent.sendEvent();
		}
		
		public function get owner():String
		{
			 return _owner;
		}
		
		public function get refreshEvent():EventSender { return _refreshEvent; }
	}
}