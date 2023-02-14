package org.goverla.controls {

	import flash.geom.Point;
	
	import mx.core.UIComponent;

	[Style(name="borderColor", type="uint", format="Color")]
	
	[Style(name="borderStyle", type="String", enumeration="none,solid")]
	
	[Style(name="borderThickness", type="Number", format="Length")]
	
	[Style(name="backgroundColor", type="uint", format="Color")]
	
	[Style(name="backgroundAlpha", type="Number")]
	
	public class InteractiveTriangle extends UIComponent {
		
		public static const TOP : String = "top";
		
		public static const RIGHT : String = "right";
		
		public static const DOWN : String = "down";
		
		public static const LEFT : String = "left";
		
		[Inspectable(enumeration="top,right,down,left")]
		public function get direction() : String {
			return _direction;
		}
		
		public function set direction(direction : String) : void {
			_direction = direction;
			invalidateDisplayList();
		}
		
		protected override function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void {
			var w : Number = unscaledWidth;
			var h : Number = unscaledHeight;
			var borderStyle : String = getStyle("borderStyle");
			var borderThickness : Number = getStyle("borderThickness");
			var borderColor : uint = getStyle("borderColor");
			var backgroundColor : uint = getStyle("backgroundColor");
			var backgroundAlpha : Number = getStyle("backgroundAlpha");
			graphics.clear();
			if (borderStyle == "solid") {
				graphics.lineStyle(borderThickness, borderColor);
			}
			graphics.beginFill(backgroundColor, backgroundAlpha);
			
			var point0 : Point;
			var point1 : Point;
			var point2 : Point;
			switch (direction) {
				case TOP :
					point0 = new Point(0, h);
					point1 = new Point(w / 2, 0);
					point2 = new Point(w, h);
					break;
				case RIGHT :
					point0 = new Point(0, 0);
					point1 = new Point(w, h / 2);
					point2 = new Point(0, h);
					break;
				case DOWN :
					point0 = new Point(w, 0);
					point1 = new Point(w / 2, h);
					point2 = new Point(0, 0);
					break;
				case LEFT :
					point0 = new Point(w, h);
					point1 = new Point(0, h / 2);
					point2 = new Point(w, 0);
					break;
				default :
			}
			
			graphics.moveTo(point0.x, point0.y);
			graphics.lineTo(point1.x, point1.y);
			graphics.lineTo(point2.x, point2.y);
			graphics.lineTo(point0.x, point0.y);

			graphics.endFill();
		}
		
		private var _direction : String = RIGHT;

	}

}