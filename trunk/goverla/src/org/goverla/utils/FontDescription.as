package org.goverla.utils {
	
	import org.goverla.constants.StyleConstants;
	
	[RemoteClass(alias="org.goverla.utils.FontDescription")]
	
	public class FontDescription {
		
		public function FontDescription(size : uint = 12) {
			_size = size;
		}
		
		public function get fontFamily() : String {
			return _fontFamily;
		}

		public function set fontFamily(value : String) : void {
			_fontFamily = value;
		}
		
		// TODO: Deprecated
		public function get name() : String {
			return fontFamily;
		}

		public function set name(value : String) : void {
			fontFamily = value;
		}
		
		public function get isBold() : Boolean {
			return _isBold;
		}

		public function set isBold(value : Boolean) : void {
			_isBold = value;
		}
		
		public function get isItalic() : Boolean {
			return _isItalic;
		}

		public function set isItalic(value : Boolean) : void {
			_isItalic = value;
		}
		
		public function get isUnderline() : Boolean {
			return _isUnderline;
		}

		public function set isUnderline(value : Boolean) : void {
			_isUnderline = value;
		}
		
		public function get size() : Number {
			return _size;
		}

		public function set size(value : Number) : void {
			_size = value;
		}
		
		public function get color() : Number {
			return _color;
		}

		public function set color(value : Number) : void {
			_color = value;
		}
		
		public function get disabledColor() : Number {
			return _disabledColor;
		}

		public function set disabledColor(value : Number) : void {
			_disabledColor = value;
		}

		public function get textRollOverColor() : Number {
			return _textRollOverColor;
		}

		public function set textRollOverColor(value : Number) : void {
			_textRollOverColor = value;
		}

		public function get textSelectedColor() : Number {
			return _textSelectedColor;
		}

		public function set textSelectedColor(value : Number) : void {
			_textSelectedColor = value;
		}

		public function get align() : String {
			return _align;
		}

		public function set align(value : String) : void {
			_align = value;
		}
		
		public function get leading() : Number {
			return _leading;
		}

		public function set leading(value : Number) : void {
			_leading = value;
		}

		public function get letterSpacing() : Number {
			return _letterSpacing;
		}

		public function set letterSpacing(value : Number) : void {
			_letterSpacing = value;
		}
		
		public function get paddingTop() : Number {
			return _paddingTop;
		}

		public function set paddingTop(value : Number) : void {
			_paddingTop = value;
		}
		
		public function get paddingRight() : Number {
			return _paddingRight;
		}

		public function set paddingRight(value : Number) : void {
			_paddingRight = value;
		}

		public function get paddingBottom() : Number {
			return _paddingBottom;
		}

		public function set paddingBottom(value : Number) : void {
			_paddingBottom = value;
		}

		public function get paddingLeft() : Number {
			return _paddingLeft;
		}

		public function set paddingLeft(value : Number) : void {
			_paddingLeft = value;
		}
		
	
		private var _fontFamily : String;

		private var _isBold : Boolean;

		private var _isItalic : Boolean;

		private var _isUnderline : Boolean;

		private var _size : Number;

		private var _color : Number;
		
		private var _disabledColor : Number;
		
		private var _textRollOverColor : Number;
		
		private var _textSelectedColor : Number;

		private var _align : String;
		
		private var _leading : Number;
		
		private var _letterSpacing : Number;
		
		private var _paddingTop : Number;
		
		private var _paddingRight : Number;
		
		private var _paddingBottom : Number;
		
		private var _paddingLeft : Number;
		
	}
	
}