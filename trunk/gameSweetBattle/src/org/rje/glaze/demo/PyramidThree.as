/**
 * glaze - 2D rigid body dynamics & game engine
 * Copyright (c) 2008, Richard Jewson
 * 
 * This project also contains work derived from the Chipmunk & APE physics engines.  
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

package org.rje.glaze.demo {
	
	import org.rje.glaze.engine.*;
	import org.rje.glaze.engine.math.*;
	import org.rje.glaze.engine.dynamics.*;
	import org.rje.glaze.engine.collision.shapes.*;

	public class PyramidThree extends Demo {
		
		public function PyramidThree( fps:int, dim:Vector2D, bfAlgo:String ) {
			super(dim,bfAlgo, 50,fps,60);
			title = "Slat Stack";
		}
		
		public override function initSpace():void {
			
			space.masslessForce.setTo(0, 200);
			createFloor();

			var material:Material = new Material(0.0, 1, 1);
			
			var width:Number = 70;
			var height:Number = 11;
			var slab:Array = Polygon.createRectangle(width, height);
			
			var startY:Number = floor - (height / 2);
			var startX:Number = dim.y/2;
			var segcount:int = 5;  
			for (var i:int = 0; i < 5; i++) {  //5
				addPolyAsNewBody( startX - width , startY, 0, slab, material);
				addPolyAsNewBody( startX + width , startY, 0, slab, material);
				for (var y:int = 0; y < segcount ; y++) {	
					for (var x:int = 0; x < y + 1; x++) {
						addPolyAsNewBody( startX - (x * width) + y * (width / 2), startY, 0, slab, material);
					}
					startY -= height;
				}
				for ( y=y; y > 0 ; y--) {
					for (x = 0; x < y + 1; x++) {
						addPolyAsNewBody( startX - (x * width) + y * (width / 2), startY, 0, slab, material);
					}
					startY -= height;
				}	
			}
		}
		
	}
	
}
