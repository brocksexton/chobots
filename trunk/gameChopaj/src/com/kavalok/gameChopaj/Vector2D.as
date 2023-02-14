package com.kavalok.gameChopaj
{
	
	public class Vector2D
	{
		public var x:Number;
		public var y:Number;

		public function Vector2D(px:Number = 0, py:Number = 0)
		{
			x = px;
			y = py;
		}
		
		public function copyVector(v:Vector2D):void
		{
			x = v.x;
			y = v.y;
		}
		
		public function setMembers( px:Number, py:Number ):void
		{
			x = px;
			y = py;
		}
		
		public function addVector( v:Vector2D ):void
		{
			x += v.x;
			y += v.y;
		}
		
		public function subVector( v:Vector2D ):void
		{
			x -= v.x;
			y -= v.y;
		}
		
		public function mulScalar( i:Number ):void
		{
			x *= i;
			y *= i;
		}
		
		public function getMulScalar(i:Number):Vector2D
		{
			return new Vector2D(x*i, y*i);
		}
		
		public function magnitude():Number
		{
			return Math.sqrt( x*x + y*y );
		}
		
		public function magnitude2():Number
		{
			return x*x + y*y;
		}
		
		public function vectorProjectionOnto(v:Vector2D):Vector2D
		{
			var res:Vector2D = v.getUnitVector();
			res.mulScalar(scalarProjectionOnto(v));
			return res;
		}
		
		public function getUnitVector():Vector2D
		{
			var len:Number = magnitude();
			var res:Vector2D = new Vector2D(x,y);
			if (len) {
				res.x /= len;
				res.y /= len;
			}
			return res;
		}
		
		// returns the scalar projection of this Vector2D onto v
		public function scalarProjectionOnto(v:Vector2D):Number
		{
			return (x*v.x + y*v.y)/v.magnitude();
		}
		
		public function toString():String
		{
			return 'Vector2D(' + x + ', ' + y + ')';
		}
		
		public function clone():Vector2D
		{
			return new Vector2D(x, y);
		}
	}
}
