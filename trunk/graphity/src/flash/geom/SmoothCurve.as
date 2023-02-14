package flash.geom
{
	import flash.display.Graphics;
	import flash.geom.Bezier;
	import flash.geom.Point;

	public class SmoothCurve
	{
		private const beziers:Array = new Array();
		
		public var start:Point;
		public var end:Point;
		
		public function SmoothCurve (startPoint:Point, endPoint:Point)
		{
			start = startPoint;
			end = endPoint;
		}
		
		public function pushControl(control:Point):void
		{
			var newBezier:Bezier;
			
			if (beziers.length > 0)
			{
				var lastBezier:Bezier = beziers[beziers.length-1];
				lastBezier.end = new Point();
				newBezier = new Bezier(lastBezier.end, control, end);
			}
			else
			{
				newBezier = new Bezier(start, control, end);
			}
			
			beziers[beziers.length] = newBezier;
		}
		
		public function update():void
		{
			var len:uint = beziers.length;
			
			if (len == 0)
				return;
			
			var prevBezier:Bezier = beziers[0];
			var currentBezier:Bezier;
			
			for (var i:uint = 1; i < len; i++)
			{
				currentBezier = beziers[i];
				var mid:Point = Point.interpolate(prevBezier.control, currentBezier.control, 0.5);
				currentBezier.start.x = mid.x;
				currentBezier.start.y = mid.y;
				prevBezier = currentBezier;
			}
		}
		
		public function draw(target:Graphics):void
		{
			update();
			
			target.moveTo(start.x, start.y);
			
			if (beziers.length == 0)
			{
				target.lineTo(end.x, end.y);
			}
			else
			{
				for each (var bezier:Bezier in beziers)
				{
					target.curveTo(bezier.control.x, bezier.control.y, bezier.end.x, bezier.end.y);
				}
			}
		}
		
	}
}
