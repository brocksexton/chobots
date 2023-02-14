package com.kavalok.admin.users.events
{
	import flash.events.Event;

	public class ShowFamilyEvent extends Event
	{
		public static const SHOW_FAMILY : String = "showFamily";
		
		public var email : String;
		
		public function ShowFamilyEvent(email : String)
		{
			super(SHOW_FAMILY, bubbles, cancelable);
			this.email = email;
		}
		
		override public function clone():Event
		{
			return new ShowFamilyEvent(email);
		}
		
	}
}