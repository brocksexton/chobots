package com.kavalok.pinball
{
	import flash.geom.Point;
	import flash.text.TextField;
	
	import org.rje.glaze.engine.math.Vector2D;
	
	public class PinballUtil
	{
		public static function getDistanceSqr(start : Vector2D, end : Point) : Number
		{
			var distY : Number = start.y - end.y;
			var distX : Number = start.x - end.x;
			return distY * distY + distX * distX;
			
		}
		public static function getParams(textField : TextField) : Object
		{
			var result : Object = new Object();
			var pairs : Array = textField.text.split("\r");
			for each(var pair : String in pairs)
			{
				var param : Array = pair.split("=");
				result[param[0]] = param[1];
			}
			return result;
			
		}

	}
}