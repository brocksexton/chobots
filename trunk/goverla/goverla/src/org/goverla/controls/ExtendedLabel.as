package org.goverla.controls {
	
	import mx.controls.Label;
	
	import org.goverla.interfaces.ITextView;
	import org.goverla.utils.Strings;

	public class ExtendedLabel extends Label implements ITextView {
		
		public function get empty() : Boolean {
			if (text != null) {
				return text.length == 0;
			} else {
				return Strings.isBlank(htmlText);
			}
		}
		
		public function get length() : int {
			return ((text != null) ? text.length : -1);
		}
		
	}
	
}