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
	
	public class Jumble extends Demo {
		
		private var addDelay:int = 100;
		private var lastAdd:int = 50;
		private var material:Material = new Material(0.1, 0.5, 1);
		
		public function Jumble( fps:int, dim:Vector2D, bfAlgo:String ) {
			super(dim,bfAlgo,15,fps,90);
			space.masslessForce.setTo(0, 500);
			title = "Multiple Shapes per Body";
		}
		
		public override function initSpace():void {
			createFloor();
		}
		
		public override function update(dt:Number):void {
			lastAdd += 1;
			if (lastAdd < addDelay) return;
			lastAdd = 0;

			var colour:uint;
			switch (Demo.randomRange( 0, 4)) {
				case 0:colour = 0x55A8DF; break;
				case 1:colour = 0x6DC770; break;
				case 2:colour = 0xF47640; break;
				case 3:colour = 0xDBE74E; break;
				case 4:colour = 0x93828C; break;	
			}			
			
			
			var body:RigidBody = new RigidBody();
			var rect1:GeometricShape = new Polygon(new Array(new Vector2D( -50, -25), new Vector2D( -50, 0), new Vector2D(50, 0), new Vector2D(50, -25)), Vector2D.zeroVect, material);
			var rect2:GeometricShape = new Polygon(new Array(new Vector2D( -50, 0)  , new Vector2D( -50, 25), new Vector2D( -30, 25), new Vector2D( -24, 12.5), new Vector2D( -24, 0)), Vector2D.zeroVect, material);
			var rect3:GeometricShape = new Polygon(new Array(new Vector2D( -24, 0)  , new Vector2D( -24, 12.5), new Vector2D( -6, 0)), Vector2D.zeroVect, material);
			var rect4:GeometricShape = new Polygon(new Array(new Vector2D(6, 0), new Vector2D( 24, 12.5), new Vector2D( 24, 0) ), Vector2D.zeroVect, material);
			var rect5:GeometricShape = new Polygon(new Array(new Vector2D( 24, 0),new Vector2D( 24, 12.5),new Vector2D( 30, 25),new Vector2D( 50, 25),new Vector2D( 50, 0)), Vector2D.zeroVect, material);
			body.addShape(rect1);
			body.addShape(rect2);
			body.addShape(rect3);
			body.addShape(rect4);
			body.addShape(rect5);

			body.p.setTo(300 + Demo.randomRange( -250, 250), Demo.randomRange( -200, -20));
			body.setAngle(Demo.randomRange(0, 2 * Math.PI));
			body.w = Demo.randomRange(-2, 2);
			space.addRigidBody(body);
			
			body = new RigidBody();
			var rect6:GeometricShape = new Polygon(Polygon.createRectangle(20, 80), Vector2D.zeroVect, material);
			var rect7:GeometricShape = new Polygon(Polygon.createRectangle(80, 20), Vector2D.zeroVect, material);
			body.addShape(rect6);
			body.addShape(rect7);
			body.p.setTo(300 + Demo.randomRange( -250, 250), Demo.randomRange( -200, -20));
			body.setAngle(Demo.randomRange(0, 2 * Math.PI));
			body.w = Demo.randomRange(-2, 2);
			space.addRigidBody(body);
		}
		
	}
	
}
