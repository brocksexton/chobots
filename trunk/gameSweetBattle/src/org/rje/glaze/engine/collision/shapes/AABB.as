/**
 * glaze - 2D rigid body dynamics & game engine
 * Copyright (c) 2008, Richard Jewson
 * 
 * This project also contains work derived from the Chipmunk & APE physics engines.  
 * Copyright (c) 2007 Scott Lembcke
 * 
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package org.rje.glaze.engine.collision.shapes {

	/*
	 * Axis Aligned Bounding Box Class
	 * Used to create retangular proxy for shapes, mainly used for fast overlap checking
	 */
	public class AABB {
		
		public var l:Number;
		public var b:Number;
		public var r:Number;
		public var t:Number;
		
		//public var xCenter:Number;
		//public var yCenter:Number;

		//public var xExtent:Number;
		//public var yExtent:Number;
		
		public var radiusSqr:Number;
		
		public function AABB( l:Number = 0 , b:Number = 0, r:Number = 0  , t:Number = 0) {
			this.l = l;
			this.b = b;
			this.r = r;
			this.t = t;
			//setExtents();
		}
		
		public function intersects( aabb:AABB ):Boolean {
			return !(aabb.l > r || aabb.r < l || aabb.t > b || aabb.b < t);
		}
		
		public function intersects2( aabb:AABB ):Boolean {
			return (l<=aabb.r && aabb.l<=r && t<=aabb.b && aabb.t<=b);
		}
		
		public function expand( aabb:AABB ):void {
			if (aabb.l < this.l) this.l = aabb.l;
			if (aabb.r > this.r) this.r = aabb.r;
			if (aabb.t < this.t) this.t = aabb.t;
			if (aabb.b > this.b) this.b = aabb.b;
			//setExtents();
		}
		/*
		public function setExtents():void {
			this.xExtent = (this.r - this.l) * 0.5;
			this.xCenter = this.l + this.xExtent;
			this.yExtent = (this.b - this.t) * 0.5;
			this.yCenter = this.t + this.yExtent;			
		}

		public function setBounds():void {
			l = xCenter - xExtent;
			b = yCenter + yExtent;
			r = xCenter + xExtent;
			t = yCenter - yExtent;	
		}		
		*/
		public static function createAt( x:Number, y:Number, xExtent:Number , yExtent:Number ):AABB {
			return new AABB( x - xExtent, y + yExtent, x + xExtent, y - yExtent );
		}
		
		public function toString():String {
			return ("l=" + l + " b=" + b + " r=" + r + " t=" + t );
		}
		
	}
	
}
