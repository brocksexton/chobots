package com.kavalok.location.entryPoints
{
	import com.kavalok.events.EventSender;
	import com.kavalok.location.LocationBase;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SpriteEntryPoint implements IEntryPoint
	{
		private var _position:Point;
		private var _content:InteractiveObject;
		
		private var _activateEvent:EventSender = new EventSender(SpriteEntryPoint);
		private var _goInEvent:EventSender = new EventSender(SpriteEntryPoint);
		private var _goOutEvent:EventSender = new EventSender(SpriteEntryPoint);
		
		protected var _location:LocationBase;
		
		public function SpriteEntryPoint(content:InteractiveObject, position:Point = null)
		{
			_content = content;
			_position = (position)
				? position.clone()
				: GraphUtils.objToPoint(content);
			
			_content.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void
		{
			_activateEvent.sendEvent(this);
		}

		public function get charPosition():Point
		{
			return _position;
		}
		
		public function goIn():void
		{
			_goInEvent.sendEvent(this);
		}
		
		public function goOut():void
		{
			_goOutEvent.sendEvent(this);
		}
		
		public function destroy():void
		{
		}
		
		public function get position():Point
		{
			 return _position;
		}
		
		public function get activateEvent():EventSender { return _activateEvent; }
		
		public function get content():InteractiveObject
		{
			 return _content;
		}
		
		public function get goInEvent():EventSender { return _goInEvent; }
		public function get goOutEvent():EventSender { return _goOutEvent; }
		
		public function set location(value:LocationBase):void
		{
			_location = value;
		}
		
	}
}