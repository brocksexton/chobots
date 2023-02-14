package com.kavalok.admin.messages
{
	import mx.containers.VBox;

	[Event(name="showFamily", type="com.kavalok.admin.users.events.ShowFamilyEvent")]
	public class MessagesBase extends VBox
	{
		[Bindable]
		public var permissionLevel : int;
		
		public function MessagesBase()
		{
			super();
		}
		
	}
}