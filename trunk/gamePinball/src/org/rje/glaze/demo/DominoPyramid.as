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

	public class DominoPyramid extends Demo {
		
		public function DominoPyramid( fps:int, dim:Vector2D, bfAlgo:String ) {
			super(dim,bfAlgo, 15,fps,90);
			title = "Domino Pyramid";
			forceFactor = 3;
		}
		
		public override function initSpace():void {
			
			space.masslessForce.setTo(0, 600);
			createFloor();
			
			var d_width:Number  = 5;
			var d_heigth:Number = 20;
			
			var dominoShape:Array = Polygon.createRectangle(d_width*2, d_heigth*2);
			
			var stackHeigth:int = 9;
			//var stackHeigth:int = 17; //17
			
			var xstart:Number = 60;
			var yp:Number = floor;
			
			var deg90AsRag:Number = Demo.deg2rad(90);
			
			var material:Material = new Material(0.0, 0.6, 0.5);
			
			var microMod:Number = 0.0;// 0.05;
			
			var newBody:RigidBody;
			
			for (var i:int = 0; i <stackHeigth ; i++) {
				
				for (var j:int = 0; j < stackHeigth - i ; j++) {
					
					var xp:Number = xstart + (3*d_heigth*j);
					
					if (i == 0) {
						newBody = addPolyAsNewBody(xp , yp - d_heigth, 0, dominoShape, material);
						newBody = addPolyAsNewBody(xp , yp - (2 * d_heigth) - d_width, deg90AsRag, dominoShape, material);
					} else {
						newBody = addPolyAsNewBody(xp , yp - d_width, deg90AsRag, dominoShape, material);
						newBody = addPolyAsNewBody(xp , yp - (2 * d_width) - d_heigth, 0, dominoShape, material);
						newBody = addPolyAsNewBody(xp , yp - (3 * d_width) - (2 * d_heigth),deg90AsRag, dominoShape, material);
					}
					if (j==0) {
						newBody = addPolyAsNewBody(xp - d_heigth + d_width , yp - (3 * d_heigth) - (4 * d_width) +((i == 0)?2 * d_width:0),0, dominoShape, material);
					}
					if (j==(stackHeigth-i-1)) {
						newBody = addPolyAsNewBody(xp + d_heigth - d_width , yp - (3 * d_heigth) - (4 * d_width) +((i == 0)?2 * d_width:0),0, dominoShape, material);
					}				
					
				}
				if (i==0) {
					yp -= microMod+(2*d_heigth)+(2*d_width);
				} else {
					yp -= microMod+(2*d_heigth)+(4*d_width);
				}
				xstart += 1.5 * d_heigth;			
			}
		}
	}
}
