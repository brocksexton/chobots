/*
Copyright (c) 2006, 2007 Alec Cove

Permission is hereby granted, free of charge, to any person obtaining a copy of this 
software and associated documentation files (the "Software"), to deal in the Software 
without restriction, including without limitation the rights to use, copy, modify, 
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
permit persons to whom the Software is furnished to do so, subject to the following 
conditions:

The above copyright notice and this permission notice shall be included in all copies 
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package org.rje.glaze.engine.math {
	
	import flash.geom.Point;

	/*
	 * 2D Vector class (linked list enabled)
	 * Used hold the x,y values of a vector.  Contains many util functions that are often
	 * inlined for performance.
	 */
	public class Vector2D {
		
		public var x:Number;
		public var y:Number;
		
		public var next:Vector2D;
		
		public var flag:Boolean;
	
		public function Vector2D(px:Number = 0, py:Number = 0) {
			x = px;
			y = py;
		}
		
		public function clone():Vector2D {
			return new Vector2D(this.x,this.y);
		}
		
		public function setTo(px:Number, py:Number):void {
			x = px;
			y = py;
		}
		
		public function copy(v:Vector2D):void {
			x = v.x;
			y = v.y;
		}
	
		public function dot(v:Vector2D):Number {
			return x * v.x + y * v.y;
		}
			
		public function cross(v:Vector2D):Number {
			return x * v.y - y * v.x;
		}
		
		public function plus(v:Vector2D):Vector2D {
			return new Vector2D(x + v.x, y + v.y); 
		}
	
		public function plusEquals(v:Vector2D):Vector2D {
			x += v.x;
			y += v.y;
			return this;
		}
		
		public function minus(v:Vector2D):Vector2D {
			return new Vector2D(x - v.x, y - v.y);    
		}
	
		public function minusEquals(v:Vector2D):Vector2D {
			x -= v.x;
			y -= v.y;
			return this;
		}
	
		public function mult(s:Number):Vector2D {
			return new Vector2D(x * s, y * s);
		}
	
		public function multEquals(s:Number):Vector2D {
			x *= s;
			y *= s;
			return this;
		}
	
		public function times(v:Vector2D):Vector2D {
			return new Vector2D(x * v.x, y * v.y);
		}
		
		public function timesEquals(v:Vector2D):Vector2D {
			x *= v.x;
			y *= v.y;
			return this;
		}

		public function div(s:Number):Vector2D {
			if (s == 0) s = 0.0001;
			return new Vector2D( x / s , y / s );
		}
		
		public function divEquals(s:Number):Vector2D {
			if (s == 0) s = 0.0001;
			x /= s;
			y /= s;
			return this;
		}
		
		public function magnitude():Number {
			return Math.sqrt(x * x + y * y);
		}
		
		public function distance(v:Vector2D):Number {
			var delta:Vector2D = this.minus(v);
			return delta.magnitude();
		}

		public function normalize():Vector2D {
			 var m:Number = magnitude();
			 if (m == 0) m = 0.0001;
			 return mult(1 / m);
		}
		
		public function normalizeEquals():Vector2D {
			 var m:Number = magnitude();
			 if (m == 0) m = 0.0001;
			 return multEquals(1 / m);
		}		
		
		public function leftHandNormal():Vector2D {
			return new Vector2D(this.y,-this.x);
		}
		
		public function rightHandNormal():Vector2D {
			return new Vector2D(-this.y,this.x);
		}
		
		public function clampMax( max:Number ):Vector2D {
			var l:Number = magnitude();
			if (l>max) {
				multEquals(max/l);
			}
			return this;
		}
		
		public function abs():Vector2D {
			return new Vector2D( (this.x < 0) ? -this.x : this.x, (this.y < 0) ? -this.y : this.y);
		}
		
		public function interpEquals( blend:Number , v:Vector2D ):Vector2D {
			this.x = this.x + blend * (v.x - this.x);
			this.y = this.y + blend * (v.y - this.y);
			return this;
		}
		
		public function projectOnto( v:Vector2D ):Vector2D {
			var dp:Number = this.dot(v);
			var f:Number  = dp / ( v.x*v.x + v.y*v.y );
			return new Vector2D( f*v.x , f*v.y);
		}
		
		public function angle( v:Vector2D ):Number {
			return Math.atan2( this.cross(v), this.dot(v) );
		}
		
		public static function forAngle( a:Number ):Vector2D {
			return new Vector2D(Math.cos(a), Math.sin(a));
		}
		
		public function forAngleEquals( a:Number ):void {
			this.x = Math.cos(a);
			this.y = Math.sin(a);
		}
		
		public function rotateByVector(v:Vector2D):Vector2D {
 	        return new Vector2D(this.x * v.x - this.y * v.y, this.x * v.y + this.y * v.x);
 	    }
		
		public function rotate(angle:Number):Vector2D {
			var a:Number = angle * Math.PI / 180;
			var cos:Number = Math.cos(a);
			var sin:Number = Math.sin(a);
			return new Vector2D( (cos*x) - (sin*y) , (cos*y) + (sin*x) );
		}
				
		public function rotateAbout( angle:Number , point:Vector2D ):Vector2D {			
			var d:Vector2D = this.minus(point).rotate(angle);
			this.x = point.x + d.x;
			this.y = point.y + d.y;
			return this;
		}
		
		public function rotateEquals(angle:Number):Vector2D {
			var a:Number = angle * Math.PI / 180;
			//var a:Number = angle;
			var cos:Number = Math.cos(a);
			var sin:Number = Math.sin(a);
			var rx:Number  = (cos*x) - (sin*y);
			var ry:Number  = (cos*y) + (sin*x);
			this.x = rx;
			this.y = ry;
			return this;
		}
		
		public static function createVectorArray( len:int ):Array {
			var vectorArray:Array = new Array();
			for (var i:int = 0; i < len; i++) {
				vectorArray[i] = new Vector2D(0, 0);
			}
			return vectorArray;
		}
		
		public function equalsZero():Boolean {
			return this.x == this.y == 0;
		}
		
		public function toPoint():Point {
			return new Point(x,y);
		}
		
		public function toString():String {
			return (x + ":" + y);
		}
		
		public static function fromString( str:String ):Vector2D {
			if (str==null)
				return null;
			var vectorParts:Array = str.split(":");
			if ((vectorParts==null)||(vectorParts.length!=2))
				return null;
			var xVal:Number = parseFloat( vectorParts[0] );
			var yVal:Number = parseFloat( vectorParts[1] );
			if ( (isNaN(xVal)) || (isNaN(yVal)) )
				return null;
			return new Vector2D( xVal , yVal  );
		}
		
		public static const zeroVect:Vector2D = new Vector2D(0, 0);
		
	}
}
