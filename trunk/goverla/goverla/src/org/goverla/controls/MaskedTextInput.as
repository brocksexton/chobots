package org.goverla.controls {

	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;
	
	import mx.utils.StringUtil;

	public class MaskedTextInput extends ExtendedTextInput {
		
		protected static const DIGIT_MASK : String = "#";
		
		protected static const ANY_MASK : String = "A";
		
		protected static const UPPERCASE_MASK : String = "C";
		
		protected static const LOWERCASE_MASK : String = "c";
		
		protected static const MASK_CHARS : String = DIGIT_MASK +
			ANY_MASK +
			UPPERCASE_MASK +
			LOWERCASE_MASK;
		
		protected static const DIGIT_CHARS : String = "0123456789";

		public function MaskedTextInput() {
			super();
		}

		override public function get text() : String {
			var result : String = (_inputMask != null ?
				StringUtil.trim(_cache.filter(notMask).map(replaceBlankChar).join("")) : super.text);
				
			return result;
		}

		override public function set text(value : String) : void {
			if (_inputMask != null) {
				_cache = initCache();
				_text = value;
				_textChanged = true;
				invalidateDisplayList();
			} else {
				super.text = value;
			}
		}
		
		public function get blankChar() : String {
			return _blankChar;
		}
		
		public function set blankChar(blankChar : String) : void {
			if (isChar(blankChar)) {
				_blankChar = blankChar;
				_textChanged = true;
				invalidateDisplayList();
			}
		}
		
		public function get inputMask() : String {
			return _inputMask;
		}
		
		public function set inputMask(inputMask : String) : void {
			if (inputMask != null) {
				addEventListener(TextEvent.TEXT_INPUT, onTextInput, true);
				addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, true);
				_inputMask = inputMask;
				_inputMaskChanged = true;
				invalidateDisplayList();
			} else {
				removeEventListener(TextEvent.TEXT_INPUT, onTextInput, true);
				removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, true);
			}
		}
		
		public function get maskedText() : String {
			var result : String;
			if (_inputMask != null) {
				var cache : Array = initCache();
				paste(_text, 0, cache);
				result = renderCache(cache);
			} else {
				result = super.text;
			}
			return result;
		}
		
		override public function get length() : int {
			if (inputMask != null) {
				return maskedText.length;
			} else {
				return super.length;
			}
		}
		
		protected function paste(input : String, position : int, cache : Array) : int {
			var i : int = position;
			var j : int = 0;

			if (input != null) {
				do {
					var success : Boolean = false;
					while (!isMask(_inputMask.charAt(i)) && i < _inputMask.length - 1) {
						i++;
					}
					if (j < input.length) {
						var char : String = input.charAt(j++);
						var maskChar : String = _inputMask.charAt(i);
						switch (maskChar) {
							case DIGIT_MASK :
								if (isDigit(char)) {
									cache[i] = char;
									i++;
									success = true;
								}
								break;
							case UPPERCASE_MASK :
								if (!isDigit(char)) {
									cache[i] = char.toUpperCase();
									i++;
									success = true;
								}
								break;
							case LOWERCASE_MASK :
								if (!isDigit(char)) {
									cache[i] = char.toLowerCase();
									i++;
									success = true;
								}
								break;
							case ANY_MASK :
								cache[i] = char;
								i++;
								success = true;
								break;
							default :
						}
					}
				} while(success);			
			}

			return i;
		}
		
		override protected function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void {
			if (_inputMaskChanged) {
				_cache = initCache();
				_inputMaskChanged = false;
				_cacheChanged = true;
			}
			
			if (_textChanged) {
				paste(_text, 0, _cache);
				_textChanged = false;
				_cacheChanged = true;
			}
			
			if (_cacheChanged) {
				super.text = renderCache(_cache);
				_cacheChanged = false;
			}
			
			if (_positionChanged) {
				setSelection(_position, _position);
				_positionChanged = false;
			}

			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		private function onTextInput(event : TextEvent) : void {
			event.preventDefault();

			var input : String = event.text;

			_position = paste(input, selectionBeginIndex, _cache);
			_positionChanged = true;
			_cacheChanged = true;
			invalidateDisplayList();
		}
		
		private function onKeyDown(event : KeyboardEvent) : void {
			var beginIndex : int;
			var endIndex : int;
			var keyCode : uint = event.keyCode;
			if (keyCode == Keyboard.BACKSPACE ||
				keyCode == Keyboard.DELETE) {
				if (selectionBeginIndex != selectionEndIndex) {
					beginIndex = selectionBeginIndex;
					endIndex = selectionEndIndex;
				} else {
					beginIndex = (keyCode == Keyboard.BACKSPACE ?
						selectionBeginIndex - 1 :
						selectionBeginIndex);
					endIndex = (keyCode == Keyboard.BACKSPACE ?
						selectionBeginIndex :
						selectionBeginIndex + 1);
				}
				clearRange(beginIndex, endIndex);
			}
			_cacheChanged = true;
			invalidateDisplayList();
		}
		
		private function clearRange(beginIndex : int, endIndex : int) : void {
			for (var i : int = beginIndex; i < endIndex; i++) {
				if (isMask(_inputMask.charAt(i))) {
					_cache[i] = _blankChar;
				}
			}
		}
		
		private function initCache() : Array {
			return _inputMask.split("").map(clearAll);
		}
		
		private function renderCache(cache : Array) : String {
			var i : int = cache.length;
			do {
				i--;
			} while (!(isMask(_inputMask.charAt(i)) && cache[i] != _blankChar) && i >= 0);
			var result : String = cache.slice(0, i + 1).join("");
			return result;
		}
		
		private function notMask(element : String, index : int, array : Array) : Boolean {
			return (_inputMask.charAt(index) != element);
		}
		
		private function replaceBlankChar(element : String, index : int, array : Array) : String {
			return (element != _blankChar ? element : " ");
		}
		
		private function clearAll(element : String, index : int, array : Array)  : String {
			return (isMask(element) ? _blankChar : element);
		}
		
		private function isDigit(char : String) : Boolean {
			return (isChar(char) == 1 && DIGIT_CHARS.indexOf(char) != -1);
		}
		
		private function isMask(char : String) : Boolean {
			return (isChar(char) && MASK_CHARS.indexOf(char) != -1);
		}
		
		private function isChar(char : String) : Boolean {
			return (char.length == 1);
		}
		
		private var _text : String;

		private var _textChanged : Boolean;
		
		private var _inputMask : String;

		private var _inputMaskChanged : Boolean;

		private var _blankChar : String = "_";

		private var _cache : Array = [];

		private var _cacheChanged : Boolean;
		
		private var _position : int;
		
		private var _positionChanged : Boolean;

	}

}