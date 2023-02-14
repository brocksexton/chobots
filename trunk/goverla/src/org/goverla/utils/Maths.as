package org.goverla.utils {
	
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import org.goverla.utils.converting.ToPropertyValueConverter;

	/**
	 * @author Maxym Hryniv
	 */
	public class Maths {
		
		public static function normalizeValue(value : Number, minimum : Number, maximum : Number) : Number {
			value = Math.max(value, minimum);
			value = Math.min(value, maximum);
			return value;
		}		
		
		public static function radiansToDegrees(value : Number) : Number {
			return value * 180 / Math.PI;
		}		

		public static function degreesToRadians(value : Number) : Number {
			return value * Math.PI / 180;
		}		

		public static function random(range : Number) : Number {
			return range > 0 ? Math.floor(Math.random()*range) : Math.ceil(Math.random()*range);
		}
		
		public static function getAxisAngle(startPoint : Point, endPoint : Point) : Number {
			var xDiff : Number = endPoint.x - startPoint.x;
			var yDiff : Number = endPoint.y - startPoint.y;
			var distance : Number = Math.sqrt(xDiff * xDiff + yDiff * yDiff);
			var angle : Number = Math.acos(xDiff/distance)
			if(startPoint.y < endPoint.y) {
				angle = - angle;
			}
			return radiansToDegrees(angle);
		}
		
		//[Mokus]: 3rd part code.
		public static function getInterpolatedValue(points : ArrayCollection, argument : Number) : Number {
		    var result : Number = 0;

		    var f : ArrayCollection = Arrays.getConverted(points, new ToPropertyValueConverter("y"));
		
		    for(var j : int = 0; j < points.length - 1; j++)
		    {
		        for(var i : int = j + 1; i < points.length; i++)
		        {
		        	var pointI : Point = Point(points.getItemAt(i));
		        	var pointJ : Point = Point(points.getItemAt(j));
		        	var fI : Number = Objects.castToNumber(f.getItemAt(i));
		        	var fJ : Number = Objects.castToNumber(f.getItemAt(j));
		        	var value : Number = ((argument - pointJ.x ) * fI - (argument - pointI.x) * fJ)/(pointI.x - pointJ.x);
		            f.setItemAt(value, i); 
		        }
		    }
		    return Objects.castToNumber(f.getItemAt(points.length - 1));
		}
	}

}