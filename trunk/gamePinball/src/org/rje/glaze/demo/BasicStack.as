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
	
	public class BasicStack extends Demo {
		
		public var side:Number = 30;// 30;
		public var width:int = 10;// 10;
		public var height:int = 18; //18
		public var offsetPcent:Number = 0.5;// 0.5;
		public var xGap:int = 0;
		
		public function BasicStack(fps:int, dim:Vector2D , bfAlgo:String) {
			super(dim,bfAlgo,18,fps,90);
			space.masslessForce.setTo(0, 300);// 300);
			title = "Basic Stack";
			forceFactor = 10;
		}
				
		public override function initSpace():void {
			createFloor();
			var offset:int;
			var boxShape:Array = Polygon.createRectangle(side, side);
			var material:Material = new Material(0.0, .8, 1);
			var startY:Number = floor - (side / 2);
			for (var y:int = 0; y < height ; y++) {
				offset = (y % 2) ? (side*offsetPcent):0;
				for (var x:int = 0; x < width; x++) {	
					var box:RigidBody = addPolyAsNewBody( offset + 150 + (x * side) + (x * xGap) , startY - (y * side) , 0, boxShape, material);
					//box.rotationLocked = true;
				}
			}
		}
	}
}
