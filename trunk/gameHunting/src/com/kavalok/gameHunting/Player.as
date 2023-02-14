package com.kavalok.gameHunting
{
	import com.kavalok.gameHunting.data.PlayerData;
	import com.kavalok.Global;
	
	public class Player
	{
		private var _data:PlayerData;
		
		public function Player(data:PlayerData)
		{
			_data = data;
		}
		
		public function get isMe():Boolean
		{
			return _data.charId == Global.charManager.charId;
		}
		
		public function get name():String
		{
			return _data.charId;
		}
		
		public function get health():int
		{
			return _data.health;
		}
		
		public function get data():PlayerData { return _data; }
		
	}
	
}