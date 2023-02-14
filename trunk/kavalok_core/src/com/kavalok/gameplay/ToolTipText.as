package com.kavalok.gameplay
{
	import com.kavalok.gameplay.controls.RectangleSprite;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ToolTipText extends Sprite
	{
		private static const ALPHA:Number = 0.75;
		private static const MARGIN:int = 2;
		private static const FONT_SIZE:int = 14; //don't change to 15 - wont work with kongregate
		
		private var _rectangle : RectangleSprite;
		private var _textField : TextField;
		private var _fontSize : int;
		private var _margin : int = MARGIN;
		private var _borderColor : uint;
		private var _backgroundColor: uint;
		private var _fontColor:uint;
		
		public function ToolTipText(fontSize : Number = NaN, leBorderColor: uint = 0x990000, leBackgroundColor: uint = 0xffffff, leFontColor: uint = 0x663300)
		{
			_borderColor = leBorderColor;
			_backgroundColor = leBackgroundColor;
			_fontColor = leFontColor;
			_fontSize = fontSize || FONT_SIZE;
			_textField = new TextField()
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.multiline = true;
			_textField.defaultTextFormat = new TextFormat("Tahoma", _fontSize, _fontColor);
			_textField.x = _margin;
			_textField.y = _margin;
			addChild(_textField);
			cacheAsBitmap = true;
			mouseEnabled = false;
			mouseChildren = false;
		
		}
		
		public function set margin(value : int) : void
		{
			_margin = value;
		}

		public function set leBorderColor(value : uint) : void
		{
			_borderColor = value;
		}
		public function set text(value : String) : void
		{
			_textField.htmlText = value;
			updateBackground();
		}
		
		private function updateBackground():void
		{
			if(_rectangle)
				removeChild(_rectangle);
			_rectangle = createRectangle();
			addChildAt(_rectangle, 0);
		}
		
		private function createRectangle():RectangleSprite { 
			var rectangle:RectangleSprite = new RectangleSprite(_textField.width + _margin * 2, _textField.height + _margin * 2);
			rectangle.suspendLayout();
			rectangle.backgroundAlpha = ALPHA;
			rectangle.borderAlpha = ALPHA;
			rectangle.backgroundColor = _backgroundColor;
			//rectangle.borderColor = 0x990000;
			rectangle.borderColor = _borderColor;
			rectangle.resumeLayout();
			rectangle.x = 0;
			rectangle.y = 0;
			return rectangle; 
		}


	}
}