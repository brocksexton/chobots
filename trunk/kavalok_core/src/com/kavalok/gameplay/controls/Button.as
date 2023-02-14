package com.kavalok.gameplay.controls
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.kavalok.events.EventSender;
	
	public class Button
	{
		private var _clickEvent:EventSender = new EventSender();
		
		private var _content:MovieClip;
		private var _hitArea:Sprite;
		
		static private const UP:int = 1;
		static private const OVER:int = 2;
		static private const DOWN:int = 3;
		
		public function get content():MovieClip
		{
			return _content;
		}
		
		public function get clickEvent():EventSender
		{
			return _clickEvent;
		}
		
		public function Button(content:MovieClip, hitArea:Sprite)
		{
			_content = content;
			_content.gotoAndStop(UP);
			
			_hitArea = hitArea || GraphUtils.addBoundsRect(_content);
			
			_hitArea.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_hitArea.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_hitArea.addEventListener(MouseEvent.CLICK, onClick);
			_hitArea.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			_hitArea.addEventListener(MouseEvent.MOUSE_UP, onRelease);
		}
		
		private function onOver(e:Event):void
		{
			_content.gotoAndStop(OVER);
		}
		
		private function onOut(e:Event):void
		{
			_content.gotoAndStop(UP);
		}
		
		private function onPress(e:Event):void
		{
			_content.gotoAndStop(DOWN);
		}
		
		private function onRelease(e:Event):void
		{
			_content.gotoAndStop(OVER);
		}
		
		private function onClick(e:Event):void
		{
			_clickEvent.sendEvent(this);
		}
	}
}