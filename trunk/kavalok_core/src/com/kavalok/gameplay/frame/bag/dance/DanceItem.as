package com.kavalok.gameplay.frame.bag.dance
{
	import com.kavalok.events.EventSender;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;


	public class DanceItem
	{
		private var _content:MovieClip;
		private var _clickEvent:EventSender=new EventSender();
		private var _order:int;

		public function DanceItem(content:MovieClip)
		{
			_content=content;
			_content.addEventListener(MouseEvent.CLICK, onClick);
			order=0;
		}
		
		public function get value() : String
		{
			return modelName;
		}

		public function get modelName():String
		{
			return _content.name;
		}

		public function get order():int
		{
			return _order;
		}

		public function set order(value:int):void
		{
			_order=value;
			_content.mcMarker.visible=(_order > 0);
			_content.orderField.visible=(_order > 0);
			_content.orderField.text=_order.toString();
		}

		private function onClick(e:MouseEvent):void
		{
			_clickEvent.sendEvent(this);
		}

		public function get clickEvent():EventSender
		{
			return _clickEvent;
		}

	}
}