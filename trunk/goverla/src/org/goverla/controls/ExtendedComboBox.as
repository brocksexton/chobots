package org.goverla.controls {

	import mx.controls.ComboBox;

	public class ExtendedComboBox extends ComboBox {
		
		public function get maxChars() : int {
			return _maxChars;
		}
		
		public function set maxChars(maxChars : int) : void {
			_maxChars = maxChars;
			_maxCharsChanged = true;
			invalidateProperties();
		}
		
		protected override function commitProperties() : void {
			super.commitProperties();
			
			if (_maxCharsChanged) {
				textInput.maxChars = _maxChars;
				_maxCharsChanged = false;
			}
		}
		
		private var _maxChars : int;
		
		private var _maxCharsChanged : Boolean;
		
	}

}