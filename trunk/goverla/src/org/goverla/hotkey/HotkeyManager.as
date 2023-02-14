package org.goverla.hotkey {
	
	/**
	 * @author Maxym Hryniv
	 */
	public class HotkeyManager {
	
		private static var _instance : HotkeyManagerInstance;
		
		public static function get instance() : HotkeyManagerInstance {
			if (_instance == null) {
				_instance = new HotkeyManagerInstance();
			}
			return _instance;
		}
		
	}
}