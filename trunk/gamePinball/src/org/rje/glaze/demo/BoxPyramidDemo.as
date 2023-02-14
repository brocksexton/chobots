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

	public class BoxPyramidDemo extends Demo {
		
		public function BoxPyramidDemo( fps:int, dim:Vector2D, bfAlgo:String ) {
			super(dim,bfAlgo, 20, fps,90);
			title = "Circle vs Stack";
		}
		
		public override function initSpace():void {
			createFloor();
			space.masslessForce.setTo(0, 150);
			var boxShape:Array = Polygon.createRectangle(30, 30);
			
			var cirBody:RigidBody = new RigidBody( RigidBody.DYNAMIC_BODY, 10, 100);
			cirBody.p.setTo( 300, floor-30); 
			var circ:GeometricShape = new Circle( 18, Vector2D.zeroVect, new Material(0.1,0.9,1));		
			cirBody.addShape(circ);
			space.addRigidBody(cirBody);
			
			for (var y:int = 0; y <16 ; y++) { //11
		
				for (var x:int = 0; x <= y; x++) { 
					
					var boxBody:RigidBody = new RigidBody();
					boxBody.p.setTo( 300 + (x * 32) - (y*16), 10 + y*32);
					var box:GeometricShape = new Polygon( boxShape, Vector2D.zeroVect, new Material(0.01,1,.8));

					boxBody.addShape(box);
					space.addRigidBody(boxBody);
				}
			}
		}
		
	}
	
}
