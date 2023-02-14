package com.kavalok.admin.chat
{
	import com.kavalok.admin.chat.events.RemoveWordEvent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;

	[Event(name="removeWord", type="com.kavalok.admin.chat.events.RemoveWordEvent")]
	public class KnownWordItemBase extends HBox
	{
		public function KnownWordItemBase()
		{
			super();
		}
		
		protected function onRemoveClick(event : MouseEvent) : void
		{
			dispatchEvent(new RemoveWordEvent(data));
		}
		
	}
}