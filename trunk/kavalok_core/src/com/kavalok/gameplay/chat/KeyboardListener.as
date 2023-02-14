package com.kavalok.gameplay.chat
{
	import com.kavalok.Global;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	public class KeyboardListener
	{
		private var _stage : Stage;
		public function KeyboardListener(stage : Stage)
		{
			_stage = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(event : KeyboardEvent) : void
		{
			if(!(_stage.focus is TextField) && Global.frame.visible)
			{
				Global.frame.setFocus();
			}
		}

	}
}