package com.kavalok.robotConfig.view.robotselect
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.IListItem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import robotConfig.McListItem;
	
	public class ListItem implements IListItem
	{
		public var data:Object;
		
		private var _content:McListItem = new McListItem();
		private var _clickEvent:EventSender = new EventSender(ListItem);
		
		public function ListItem(data:Object)
		{
			this.data = data;
			selected = false;
			RobotConfig.instance.initTextField(_content.captionField);
			_content.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			_clickEvent.sendEvent(this);
		}
		
		public function set selected(value:Boolean):void
		{
			 if (value)
			 	_content.gotoAndStop(2);
			 else
			 	_content.gotoAndStop(1);
		}
		
		public function set caption(value:String):void
		{
			_content.captionField.text = value;
		}
		
		public function get clickEvent():EventSender { return _clickEvent; }
		
		public function get content():Sprite
		{
			 return _content;
		}

	}
}