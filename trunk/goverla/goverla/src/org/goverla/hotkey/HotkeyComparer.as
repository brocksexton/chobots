package org.goverla.hotkey {
	
	import org.goverla.interfaces.IComparer;
	import org.goverla.utils.comparing.ComparingResult;

	internal class HotkeyComparer implements IComparer {
		
		public function compare(object1:Object, object2:Object):int {
			var result : int = ComparingResult.SMALLER;
			var firstHotkey : Hotkey = Hotkey(object1);
			var secondHotkey : Hotkey = Hotkey(object2);
			if (firstHotkey.key == secondHotkey.key
				&& firstHotkey.isCtrlPressed == secondHotkey.isCtrlPressed
				&& firstHotkey.isShiftPressed == secondHotkey.isShiftPressed
				&& firstHotkey.isAltPressed == secondHotkey.isAltPressed) {
					result = ComparingResult.EQUALS;
			}
			return result;
		}
		
	}
	
}