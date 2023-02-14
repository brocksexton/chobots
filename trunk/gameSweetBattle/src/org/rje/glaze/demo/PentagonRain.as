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

	public class PentagonRain extends Demo {
		
		private var pentagonArray:Array = new Array();
		private var numPentagons:int =500;
		
		private var refreshDelay:int = 3;
		private var lastRefresh:int = 50;
		
		public function PentagonRain(fps:int, dim:Vector2D, bfAlgo:String) {
			super(dim,bfAlgo,4,fps,30);
			space.masslessForce.setTo(0, 150);
			forceFactor = 0.1;
			title = "PentagonRain";
		}
				
		public override function initSpace():void {
			var triangleOb:Array = new Array( new Vector2D( -15, 15), new Vector2D( 15, 15), new Vector2D( 0, -10));
			var pentagonOb:Array = Polygon.createBlobConvexPoly(5, 10);
			
			space.defaultStaticBody.lock();
			
			var obsticalMaterial:Material = new Material(1, .1, 1);
			for (var i:int = 0; i < 8; i++) {	
				for (var j:int = 0; j < 7;j++) {
					var stagger:Number = (j%2)*40;
					var offset:Vector2D = new Vector2D(i * 80 + stagger, 80 + j * 70 );
					var triObsticale:GeometricShape = space.defaultStaticBody.addShape(new Polygon(triangleOb, offset, obsticalMaterial));
					triObsticale.fillColour = staticColour;
				}
			}
			space.defaultStaticBody.unlock();
			
			var pentagonMaterial:Material = new Material(0.2, 0, 1);
			for (i = 0; i < numPentagons; i++) {
				var pentagon:RigidBody = new RigidBody(RigidBody.DYNAMIC_BODY, 1, 500);
				pentagon.p.setTo(300 + Demo.randomRange( -300, 300), Demo.randomRange( -50, -150));
				pentagonArray.push(pentagon);
				var pentagonShape:GeometricShape = new Polygon(pentagonOb, Vector2D.zeroVect, pentagonMaterial);
				pentagon.addShape(pentagonShape);
				space.addRigidBody(pentagon);
			}
		}
		
		public override function update(dt:Number):void {
			lastRefresh += 1;
			if (lastRefresh < refreshDelay) return;
			lastRefresh++;

			for ( var i:int = 0; i < numPentagons; i++) {
				var pentagon:RigidBody = pentagonArray[i];
				if ((pentagon.p.y > dim.y + 20)||(pentagon.p.x < -20)||(pentagon.p.y > dim.x + 20)||(pentagon.p.x > dim.y+20)){
					pentagon.p.setTo(300 + Demo.randomRange( -280, 280), Demo.randomRange( -50, -100));
					pentagon.v.setTo( Demo.randomRange(-10, 10), Demo.randomRange( 10, 100));
				}
			}

		}
		
	}
	
}
