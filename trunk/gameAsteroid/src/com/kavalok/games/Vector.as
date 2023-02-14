package com.kavalok.games
{
	
	public class Vector
	{
		public var x:Number;
		public var y:Number;

		public function Vector(px:Number = 0, py:Number = 0)
		{
			x = px;
			y = py;
		}
		
		public function copyVector(v:Vector):void
		{
			x = v.x;
			y = v.y;
		}
		
		public function setMembers( px:Number, py:Number ):void
		{
			x = px;
			y = py;
		}
		
		public function addVector( v:Vector ):void
		{
			x += v.x;
			y += v.y;
		}
		
		public function subVector( v:Vector ):void
		{
			x -= v.x;
			y -= v.y;
		}
		
		public function mulScalar( i:Number ):void
		{
			x *= i;
			y *= i;
		}
		
		public function getMulScalar(i:Number):Vector
		{
			return new Vector(x*i, y*i);
		}
		
		public function magnitude():Number
		{
			return Math.sqrt( x*x + y*y );
		}
		
		public function magnitude2():Number
		{
			return x*x + y*y;
		}
		
		public function vectorProjectionOnto(v:Vector):Vector
		{
			var res:Vector = v.getUnitVector();
			res.mulScalar(scalarProjectionOnto(v));
			return res;
		}
		
		public function getUnitVector():Vector
		{
			var len:Number = magnitude();
			var res:Vector = new Vector(x,y);
			if (len) {
				res.x /= len;
				res.y /= len;
			}
			return res;
		}
		
		// returns the scalar projection of this vector onto v
		public function scalarProjectionOnto(v:Vector):Number
		{
			return (x*v.x + y*v.y)/v.magnitude();
		}
		
		public function toString():String
		{
			return 'Vector(' + x + ', ' + y + ')';
		}
	}
}
