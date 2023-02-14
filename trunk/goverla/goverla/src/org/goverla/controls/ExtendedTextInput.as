package org.goverla.controls {
	
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import org.goverla.constants.StyleNames;
	import org.goverla.interfaces.ITextEdit;
	import org.goverla.utils.Strings;
	import org.goverla.utils.TextFormatter;

	public class ExtendedTextInput extends TextInput implements ITextEdit {
		
		public function get empty() : Boolean {
			if (super.text != null) {
				return super.text.length == 0;
			} else {
				return Strings.isBlank(super.htmlText);
			}
		}
		
		public function get defaultText() : String {
			return _defaultText;
		}
		
		public function set defaultText(value : String) : void {
			_defaultText = value;
			_defaultTextChanged = true;
			invalidateProperties();
		}
		
		override public function get text() : String {
			if (_showingDefaultText) {
				return "";
			} else {
				return TextFormatter.getTextWithoutCRLF(super.text);
			}
		}
		
		override public function set text(value : String) : void {
			setText(value);
			_textChanged = true;
			invalidateProperties();
		}
		
		override public function get htmlText() : String {
			if (_showingDefaultText) {
				return "";
			} else {
				return super.htmlText;
			}
		}
		
		override public function set htmlText(value : String) : void {
			setHtmlText(value);
			_htmlTextChanged = true;
			invalidateProperties();
		}
		
		public function ExtendedTextInput() {
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function setStyle(styleProp : String, newValue : *) : void {
			var value : * = newValue;
			if (styleProp == StyleNames.BORDER_COLOR && isNaN(value as Number)) {
				value = _borderColor;
			}
			super.setStyle(styleProp, value);
		}
		
		protected function onCreationComplete(event : FlexEvent) : void {
			_borderColor = getStyle(StyleNames.BORDER_COLOR);
		}
		
		override protected function commitProperties() : void {
			if ((_textChanged || _htmlTextChanged || _defaultTextChanged) && empty) {
				setText(_defaultText, true);
			}
			
			_textChanged = false;
			_htmlTextChanged = false;
			_defaultTextChanged = false;
			
			super.commitProperties();
		}
		
		override protected function focusInHandler(event : FocusEvent) : void {
			super.focusInHandler(event);
			if (contains(DisplayObject(event.target)) && _showingDefaultText) {
				setText("", false, true);
			}
		}
		
		override protected function focusOutHandler(event : FocusEvent) : void {
			super.focusOutHandler(event);
			if (contains(DisplayObject(event.target)) && empty) {
				setText(_defaultText, true);
			}
		}
		
		private function setText(value : String, isDefaultText : Boolean = false, noValueCommit : Boolean = false) : void {
			if (isDefaultText || noValueCommit) {
				addEventListener(FlexEvent.VALUE_COMMIT, onValueCommit, false, 1.0);
			}
			super.text = value;
			_showingDefaultText = isDefaultText;
		}
		
		private function onValueCommit(event : FlexEvent) : void {
			event.stopImmediatePropagation();
			removeEventListener(FlexEvent.VALUE_COMMIT, onValueCommit);
		}
		
		private function setHtmlText(value : String, isDefaultText : Boolean = false) : void {
			super.htmlText = value;
			_showingDefaultText = isDefaultText;
		}
		
		private var _defaultText : String = "";
		
		private var _defaultTextChanged : Boolean;
		
		private var _textChanged : Boolean;
		
		private var _htmlTextChanged : Boolean;
		
		private var _showingDefaultText : Boolean;
		
		private var _borderColor : Number;
		
	}
	
}