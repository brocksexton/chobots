package com.kavalok.gameplay.controls
{
	import com.kavalok.Global;
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ColorPicker
	{
		static private const DEFAULT_COLOR:int = 0xFFFFFF;
		
		private var _clickEvent:EventSender = new EventSender(ColorPicker);
		
		private var _content:Sprite;
		private var _color:int = DEFAULT_COLOR;
		
		public function ColorPicker(content:Sprite)
		{
			_content = content;
			_content.buttonMode = true;
			_content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			dispatchColor();
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			dispatchColor();
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function dispatchColor():void
		{
			_color = GraphUtils.getPixel(_content, _content.mouseX, _content.mouseY);
			_clickEvent.sendEvent(this);
		}
		
		public function get color():int
		{
			 return _color;
		}
		
		public function get clickEvent():EventSender
		{
			 return _clickEvent;
		}
		
		public function get content():Sprite
		{
			 return _content;
		}
	}
}