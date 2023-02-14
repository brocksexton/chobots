package com.kavalok.admin.chat.events
{
	import flash.events.Event;

	public class RemoveWordEvent extends Event
	{
		public static const REMOVE : String = "removeWord";
		
		public var word : Object;
		
		public function RemoveWordEvent(word : Object)
		{
			super(REMOVE);
			this.word = word;
		}
		
	}
}