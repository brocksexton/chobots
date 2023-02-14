package com.kavalok.gameplay.controls
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ToggleButton extends ButtonBase
	{
		
		private var _toggle : Boolean;
		
		public function ToggleButton(content : MovieClip)
		{
			super(content);
			content.addEventListener(MouseEvent.CLICK, onClick);
			content.buttonMode = true;
			content.mouseChildren = false;
			content.useHandCursor = true;
		}
		
		public function get toggle() : Boolean
		{
			return _toggle;
		}
		
		public function set toggle(value : Boolean) : void
		{
			_toggle = value;
			invalidate();
		}
		
		private function onClick(event : MouseEvent) : void
		{
			toggle = !toggle;
		}
		
		override protected function invalidate() : void
		{
			super.invalidate();
			if((over && highliteOnOver) || _toggle)
			{
				if(_toggle && content.totalFrames > 2)
				{
					content.gotoAndStop(3);
				}
				else
				{
					content.gotoAndStop(2);
				}
			}
			else
			{
				content.gotoAndStop(1);
			}
			
		}
		
	}
}