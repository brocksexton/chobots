package com.kavalok.danceConstructor
{
	import com.kavalok.constants.Modules;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ToolTips;
	
	import flash.events.MouseEvent;

	public class FrameView extends BoneModelViewBase
	{
		private var _content : McFrame = new McFrame();
		private var _selectEvent : EventSender = new EventSender();
		private var _removeEvent : EventSender = new EventSender();
		private var _addEvent : EventSender = new EventSender();
		
		public function FrameView(charInfo : Object)
		{
			super(_content, charInfo);
			model.mouseEnabled = false;
			model.mouseChildren = false;
			_content.addEventListener(MouseEvent.CLICK, onClick);
			_content.minusButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_content.plusButton.addEventListener(MouseEvent.CLICK, onPlusClick);
			ToolTips.registerObject(_content.plusButton, "addFrame", Modules.DANCE_CONSTRUCTOR);
			ToolTips.registerObject(_content.minusButton, "removeFrame", Modules.DANCE_CONSTRUCTOR);
		}
		
		public function get selectEvent() : EventSender
		{
			return _selectEvent;
		}
		public function get addEvent() : EventSender
		{
			return _addEvent;
		}
		public function get removeEvent() : EventSender
		{
			return _removeEvent;
		}
		public function set closeEnabled(value : Boolean) : void
		{
			_content.minusButton.visible = value;
		}
		
		public function set plusVisible(value : Boolean) : void
		{
			_content.plusButton.visible = value;
		}
		public function set coords(value : Object) : void
		{
			bone.coords = value;
		}
		public function get coords() : Object
		{
			return bone.coords;
		}

		public function cloneCoords() : Object
		{
			var result : Object = {};
			var source : Object = coords;
			for(var prop : String in source)
				result[prop] = source[prop].clone();

			return result;
		}

		private function onCloseClick(event : MouseEvent) : void
		{
			removeEvent.sendEvent(this);
			event.stopPropagation();
		}
		private function onPlusClick(event : MouseEvent) : void
		{
			addEvent.sendEvent(this);
			event.stopPropagation();
		}
		private function onClick(event : MouseEvent) : void
		{
			selectEvent.sendEvent(this);
		}

		
	}
}