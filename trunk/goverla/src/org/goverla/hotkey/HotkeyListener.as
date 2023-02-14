package org.goverla.hotkey {
	
	import org.goverla.errors.IllegalStateError;

	internal class HotkeyListener {

		public function HotkeyListener(hotkey : Hotkey, handler : Function) {
			_hotkey = hotkey;
			_handler = handler;
		}
		
		public function get handler() : Function {
			return _handler;
		}
		
		public function get hotkey() : Hotkey {
			return _hotkey;
		}
		
		private var _hotkey : Hotkey;
		
		private var _handler : Function;
		
	}
	
}