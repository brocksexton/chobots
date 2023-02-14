package com.kavalok.gameplay.frame.bag.dance
{
	import com.kavalok.Global;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.windows.McCustomDanceButton;
	
	import flash.events.MouseEvent;

	public class CustomDanceItem extends DanceItem
	{
		private var _content : McCustomDanceButton;
		private var _editEvent : EventSender = new EventSender();
		public function CustomDanceItem(content:McCustomDanceButton)
		{
			_content = content;
			super(content);
			_content.editButton.addEventListener(MouseEvent.CLICK, onEditClick);
			ToolTips.registerObject(_content.editButton, "editDance", ResourceBundles.KAVALOK);
		}
		
		public function get editEvent():EventSender
		{
			return _editEvent;
		}
		override public function get value():String
		{
			return new DanceSerializer().serialize(dance);
		}
		public function get dance():Array
		{
			return Global.charManager.dances[customDanceIndex];
			
		}
		public function get hasDance():Boolean
		{
			return dance != null;
		}

		public function get customDanceIndex():int
		{
			return _content.name.split("_")[1];
		}
		
		private function onEditClick(event : MouseEvent) : void
		{
			editEvent.sendEvent(this);
			event.stopPropagation();
		}

	}
}