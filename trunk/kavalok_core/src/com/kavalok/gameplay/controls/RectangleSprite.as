package com.kavalok.gameplay.controls
{
	import flash.display.Sprite;

	public class RectangleSprite extends Sprite
	{
		private var _borderColor : Number = 0;
		private var _borderAlpha : Number = 1;
		private var _backgroundColor : Number = 0xffffff;
		private var _backgroundAlpha : Number = 1;
		private var _cornerRadius : Number = 5;

		private var _layoutSuspended : Boolean;
		
		private var _width : Number;
		private var _height : Number;
		
		public function RectangleSprite(width : Number = 10, height : Number = 10)
		{
			super();
			suspendLayout();
			this.width = width;
			this.height = height;
			resumeLayout();
		}
		
		public function get borderColor() : Number
		{
			return _borderColor;
		}
		
		public function set borderColor(value : Number) : void
		{
			if(value == borderColor)
				return;
			_borderColor = value;
			updateLayout();
		}

		public function get borderAlpha() : Number
		{
			return _borderAlpha;
		}
		
		public function set borderAlpha(value : Number) : void
		{
			if(value == borderAlpha)
				return;
			_borderAlpha = value;
			updateLayout();
		}

		public function get backgroundAlpha() : Number
		{
			return _backgroundAlpha;
		}
		
		public function set backgroundAlpha(value : Number) : void
		{
			if(value == backgroundAlpha)
				return;
			_backgroundAlpha = value;
			updateLayout();
		}

		public function get backgroundColor() : Number
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value : Number) : void
		{
			if(value == backgroundColor)
				return;
			_backgroundColor = value;
			updateLayout();
		}
		
		public function get cornerRadius() : Number
		{
			return _cornerRadius;
		}
		
		public function set cornerRadius(value : Number) : void
		{
			if(value == cornerRadius)
				return;
			_cornerRadius = value;
			updateLayout();
		}
		
		override public function set width(value : Number) : void
		{
			_width = value;
			updateLayout();
		}

		override public function get width() : Number
		{
			return _width;
		}

		override public function set height(value : Number) : void
		{
			_height = value;
			updateLayout();
		}
		
		override public function get height() : Number
		{
			return _height;
		}
		
		public function resumeLayout() : void
		{
			_layoutSuspended = false;
			updateLayout();
		}
		public function suspendLayout() : void
		{
			_layoutSuspended = true;
		}
		
		
		
		public function updateLayout() : void
		{
			if(_layoutSuspended)
				return;
			graphics.clear();
			graphics.lineStyle(1, borderColor, borderAlpha, true);
			graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.drawRoundRectComplex(0, 0, width, height, cornerRadius, cornerRadius, cornerRadius, cornerRadius);
			graphics.endFill();
			
		}
		
	}
}