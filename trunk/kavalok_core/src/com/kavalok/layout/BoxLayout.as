package com.kavalok.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class BoxLayout extends LayoutBase
	{
		public var margin : Number = 0;
		
		private var _positionProperty : String;
		private var _sizeProperty : String;
		
		public function BoxLayout(container : DisplayObjectContainer, positionProperty : String, sizeProperty : String)
		{
			super(container);
			_positionProperty = positionProperty;
			_sizeProperty = sizeProperty;
		}
		
		override public function apply() : void
		{
			var currentPosition : Number = 0;
			
			for(var i : uint = 0; i < container.numChildren; i++)
			{
				var object : DisplayObject = container.getChildAt(i);
				object[_positionProperty] = currentPosition;
				currentPosition += object[_sizeProperty] + margin;
			}
		}

	}
}