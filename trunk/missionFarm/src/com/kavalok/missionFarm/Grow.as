package com.kavalok.missionFarm 
{
	import com.kavalok.gameplay.MousePointer;
	import flash.events.MouseEvent;
	import com.kavalok.events.EventSender;
	
	public class Grow
	{
		public var busy:Boolean = false;
		public var badChar:BadChar;
		public var locked:Boolean = false;;
		
		private var _pressEvent:EventSender = new EventSender();
		private var _lockEvent:EventSender = new EventSender();
		private var _enabled:Boolean = true;
		
		private var _id:String = null;
		private var _model:McGrow;
		
		public function Grow(id:String, fade:Boolean = true)
		{
			_id = id;
			_model = new McGrow();
			_model.btn.alpha = 0;
			_model.btn.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			
			if (!fade) 
				_model.mcAnim.gotoAndStop(_model.mcAnim.totalFrames);
		}
		
		private function onPress(e:MouseEvent):void 
		{
			_pressEvent.sendEvent(this);
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			
			var pointer:Class = (_enabled)
				? MousePointer.HAND
				: MousePointer.BLOCKED;
			
			MousePointer.registerObject(model.btn, pointer);
		}
		
		public function get enabled():Boolean { return _enabled; }
		
		public function get pressEvent():EventSender { return _pressEvent; }
		
		public function get model():McGrow { return _model; }
		
		public function get id():String { return _id; }
		
		public function get lockEvent():EventSender { return _lockEvent; }
	}	
}