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

package org.rje.glaze.engine.math {
	
	/*
	 * 2D Axis class (linked list enabled)
	 * Used hold the x,y values of the axis + the distance from the origin
	 */
	public class Axis {
		
		public var n:Vector2D;		//Axis Normal
		public var d:Number;		//Distance From Origin
		
		public var next:Axis;
		
		public function Axis( n:Vector2D , d:Number ) {
			this.n = n;
			this.d = d;
		}
		
		public function clone():Axis {
			return new Axis( this.n.clone(), this.d );
		}
		
		public function toString():String {
			return ("Axis= " + n.x + ":" + n.y + " d=" + d);
		}
		
	}
	
}
