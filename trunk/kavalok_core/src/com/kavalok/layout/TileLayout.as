package com.kavalok.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	public class TileLayout extends LayoutBase
	{
		public static const VERTICAL : String = "vertical";
		public static const HORIZONTAL : String = "horizontal";
		
		public var maxItems : uint = 1;
		public var direction : String = HORIZONTAL;
		public var offset : Point = new Point(0,0);
		public var distance:int = 0;
		
		public function TileLayout(container : DisplayObjectContainer)
		{
			super(container);
		}
		
		override public function apply() : void
		{
			var currentWidth : Number = offset.x;
			var currentHeight : Number = offset.y;
			var currentIndex : uint = 0;
			for(var i : uint = 0; i < container.numChildren; i++)
			{
				var object : DisplayObject = container.getChildAt(i);
				object.x = currentWidth;
				object.y = currentHeight;
				currentIndex++;
				if(direction == HORIZONTAL)
				{
					if(currentIndex >= maxItems && maxItems > 0)
					{
						currentHeight += object.height + distance;
						currentWidth = 0;
						currentIndex = 0;
					}
					else
					{
						currentWidth += object.width + distance;
					}
				}
				else
				{
					if(currentIndex >= maxItems && maxItems > 0)
					{
						currentWidth += object.width + distance;
						currentHeight = 0;
						currentIndex = 0;
					}
					else
					{
						currentHeight += object.height + distance;
					}
				}
				
			}
			
		}

	}
}