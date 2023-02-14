package common.utils
{
	import flash.geom.Point;
	
	/**
	* ...
	* @author Canab
	*/
	public class MathUtil
	{
		private static var _PI:Number = Math.PI;
		private static var _2PI:Number = 2 * Math.PI;
		
		public function MathUtil()
		{
			super();
		}
		
		public static function distance2(p1:Point, p2:Point):Number
		{
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			
			return dx*dx + dy*dy;
		}
		
		public static function distance(p1:Point, p2:Point):Number
		{
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			
			return Math.sqrt(dx*dx + dy*dy);
		}
		
		public static function claimRange(value:Number, min:Number, max:Number):Number
		{
			if (value < min)
				return min;
			else if (value > max)
				return max;
			else
				return value;
		}
		
		public static function randomInt(maxValue:int):int
		{
			return int(Math.random() * maxValue);
		}
		
		public static function angleDiff(angle1:Number, angle2:Number):Number
		{
			angle1 %= _2PI;
			angle2 %= _2PI;
			
			if (angle1 < 0) angle1 += _2PI;
			if (angle2 < 0) angle2 += _2PI;
			
			var diff:Number = angle2 - angle1;
			
			if (diff < -_PI) diff += _2PI;
			if (diff > _PI) diff -= _2PI;
			
			return diff;
		}
		
		static public function sign(num:Number):int
		{
			if (num > 0)
				return 1;
			else if (num < 0)
				return -1;
			else
				return 0;
		}
	}
}