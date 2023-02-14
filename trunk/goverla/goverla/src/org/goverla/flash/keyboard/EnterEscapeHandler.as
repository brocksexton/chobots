package org.goverla.flash.keyboard {
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.core.UIComponent;
	
	public class EnterEscapeHandler	{
		
		public function EnterEscapeHandler(control : UIComponent, enterHandler : Function, escapeHandler : Function) {
			control.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, true);
			_enterHandler = enterHandler;
			_escapeHandler = escapeHandler;
		}
		
		private function onKeyUp(event : KeyboardEvent) : void {
			if (event.keyCode == Keyboard.ENTER) {
				handle(event, _enterHandler);
			} else if (event.keyCode == Keyboard.ESCAPE) {
				handle(event, _escapeHandler);
			}
		}
		
		private function handle(event : KeyboardEvent, handler : Function) : void {
			if (handler != null) {
				handler(event);
			}
		}
		
		private var _enterHandler : Function;
		
		private var _escapeHandler : Function;

	}
	
}