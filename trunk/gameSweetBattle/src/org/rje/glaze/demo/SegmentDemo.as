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
	
	public class SegmentDemo extends Demo {
		
		private var bodyArray:Array = new Array();
		private var numBodies:int = 150;// 200;
		
		private var refreshDelay:int = 10;
		private var lastRefresh:int = 50;
		
		public function SegmentDemo(fps:int, dim:Vector2D, bfAlgo:String) {
			super(dim,bfAlgo,2,fps,120);
			space.masslessForce.setTo(0, 400);
			title = "Segments";
		}
				
		public override function initSpace():void {

			space.defaultStaticBody.addShape( new Segment( new Vector2D(0, 0), new Vector2D(110, 100), 4));
			space.defaultStaticBody.addShape( new Segment( new Vector2D(110, 100), new Vector2D(220, 200), 4));
			
			space.defaultStaticBody.addShape( new Segment( new Vector2D(490, 100), new Vector2D(600, 0),  4));
			space.defaultStaticBody.addShape( new Segment( new Vector2D(380, 200), new Vector2D(490,100),  4));
			
			space.defaultStaticBody.addShape( new Segment( new Vector2D(200, 350), new Vector2D(300, 310), 4));
			space.defaultStaticBody.addShape( new Segment( new Vector2D(400, 350), new Vector2D(300, 310), 4));
			
			space.defaultStaticBody.addShape( new Segment( new Vector2D(100, 400), new Vector2D(200, 500), 2));
			space.defaultStaticBody.addShape( new Segment( new Vector2D(500, 400), new Vector2D(400, 500), 2));
			
			var material:Material = new Material(0.0, 0.1, 1);
			
			for (var i:int = 0; i < numBodies; i++) {
				var newBody:RigidBody = new RigidBody();
				newBody.p.setTo(300 + Demo.randomRange( -200, 200), Demo.randomRange( -50, -150));
				bodyArray.push(newBody);
				
				var newShape:GeometricShape;
				if ( Demo.randomRange(0, 2)>0) {
					newShape = new Polygon(Polygon.createBlobConvexPoly(Demo.randomRange(3, 4), Demo.randomRange(12, 20)), Vector2D.zeroVect, material);
				} else {
					newShape = new Circle(Demo.randomRange(8, 20), Vector2D.zeroVect);
				}
				newBody.addShape(newShape);
				space.addRigidBody(newBody);
			}

		}
		
		public override function update(dt:Number):void {
			lastRefresh += 1;
			if (lastRefresh < refreshDelay) return;
			lastRefresh = 0;

			for ( var i:int = 0; i < numBodies; i++) {
				var body:RigidBody = bodyArray[i];
				if ((body.p.y > dim.y + 20)||(body.p.x < -20)||(body.p.y > dim.x + 20)){
					body.p.setTo(300 + Demo.randomRange( -200, 200), Demo.randomRange( -50, -100));
					body.v.setTo( Demo.randomRange(-10, 10), Demo.randomRange( 10, 100));
				}
			}
			//space.activeShapes.sort(GeometricShape.sortOnAABBDecending);
		}
	}
	
}
