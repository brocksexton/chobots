package com.kavalok.location.fish
{
	public class FishType
	{
		
		private var _id:int;
		private var _name:String;
		private var _probability:int;
		private var _rodTypeName:String;
		private var _nice_name:String;
		
		private var _isItem:Boolean;
		
		public function FishType(id:int, name:String, probability:int, rodTypeName:String, nice_name:String, isItem:Boolean = true)
		{
			_id = id;
			_name = name;
			_rodTypeName = rodTypeName;
			_probability = probability;
			_nice_name = nice_name;
			_isItem = isItem;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get rodTypeName():String
		{
			return _rodTypeName;
		}

		public function set rodTypeName(value:String):void
		{
			_rodTypeName = value;
		}

		public function get probability():int
		{
			return _probability;
		}

		public function set probability(value:int):void
		{
			_probability = value;
		}

		public function get nice_name():String
		{
			return _nice_name;
		}

		public function set nice_name(value:String):void
		{
			_nice_name = value;
		}

		public function get isItem():Boolean
		{
			return _isItem;
		}

		public function set isItem(value:Boolean):void
		{
			_isItem = value;
		}


	}
}