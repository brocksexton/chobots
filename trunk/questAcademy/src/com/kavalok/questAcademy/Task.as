package com.kavalok.questAcademy
{
	public class Task
	{
		public var question:String;
		public var answers:Array = [];
		public var correctNum:int;
		
		public function toString():String
		{
			return question + '\n' + answers;
		}
	}
}