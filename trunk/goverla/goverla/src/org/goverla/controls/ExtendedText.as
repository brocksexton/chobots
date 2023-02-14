package org.goverla.controls {
	
	import mx.controls.Text;
	
	import org.goverla.interfaces.ITextView;
	import org.goverla.utils.Strings;
	
	public class ExtendedText extends Text implements ITextView {
		
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