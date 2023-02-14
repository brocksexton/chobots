package com.kavalok.gameplay.controls
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class EnabledButton extends ButtonBase
	{
		private var _enabled : Boolean = true;
		private var _down : Boolean;
		
		public function EnabledButton(content : MovieClip)
		{
			super(content);
			content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			content.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function get enabled() : Boolean
		{
			return _enabled;
		} 
		public function set enabled(value : Boolean) : void
		{
			if(_enabled != value)
			{
				_enabled = value;
				content.mouseEnabled = value; 
				invalidate();
			}
		}
		
		override protected function invalidate():void
		{
			if(!over)
				_down = false;
			if(!enabled)
			{
				content.gotoAndStop(4);
				return;
			}
			super.invalidate();
			if(_down)
			{
				content.gotoAndStop(3);
			}
		}
		
		override protected function onMouseOut():void
		{
			_down = false;
			super.onMouseOut();
		}
		
		private function onMouseUp(event : MouseEvent) : void
		{
			_down = false;
			invalidate();
		}
		
		private function onMouseDown(event : MouseEvent) : void
		{
			_down = true;
			invalidate();
		}

	}
}