package com.kavalok.char
{

	public class Directions 
	{
		public static const RIGHT:int = 0;
		public static const RIGHT_DOWN:int = 1;
		public static const DOWN:int = 2;
		public static const LEFT_DOWN:int = 3;
		public static const LEFT:int = 4;
		public static const LEFT_UP:int = 5;
		public static const UP:int = 6;
		public static const RIGHT_UP:int = 7;
		
		public static const invertDirections:Object = 
		{
			0: 4,
			1: 5,
			2: 6,
			3: 7,
			4: 0,
			5: 1,
			6: 2,
			7: 3
		}
		
		public static function getDirection(xDif:Number, yDif:Number):int
		{
			var d:int = (Math.atan2(yDif, xDif)) / Math.PI * 180;
			
			if (d < 0)
				d += 360;
			
			return Math.round(d / 45) % 8;
		}
		
	}
}
