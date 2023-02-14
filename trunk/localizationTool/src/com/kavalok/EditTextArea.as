package com.kavalok
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.TextArea;

	public class EditTextArea extends TextArea
	{
		public function EditTextArea()
		{
			super();
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyUp);
		}
		private function onKeyUp(event : KeyboardEvent) : void
		{
			if(event.keyCode == Keyboard.ENTER)
				event.stopImmediatePropagation();
		}
		
	}
}