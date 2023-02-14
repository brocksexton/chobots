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
	import org.rje.glaze.engine.dynamics.joints.*;
	import org.rje.glaze.engine.collision.shapes.*;
	
	public class JointDemo extends Demo {
		
		public function JointDemo(fps:int, dim:Vector2D, bfAlgo:String) {
			super(dim,bfAlgo,15,fps,90);
			space.masslessForce.setTo(0, 300);
			title = "Joints";
		}
				
		public override function initSpace():void {
			
			var material:Material = new Material(0.1, 0.7, 3);	
			
			var chain1:RigidBody = addPolyAsNewBody( 200, 150, 0, Polygon.createRectangle(100, 20) , material );
			chain1.group = 1;
			var chain2:RigidBody = addPolyAsNewBody( 300, 150, 0, Polygon.createRectangle(100, 20) , material );
			chain2.group = 1;
			var chain3:RigidBody = addPolyAsNewBody( 400, 150, 0, Polygon.createRectangle(100, 20) , material );
			chain3.group = 1;
			
			var cirBody:RigidBody = new RigidBody();
			cirBody.p.setTo( 500, 150); 
			var circ:GeometricShape = new Circle( 30, Vector2D.zeroVect, new Material(0.0,0.9,1));		
			cirBody.addShape(circ);
			space.addRigidBody(cirBody);		
			
			var chain4:RigidBody = addPolyAsNewBody( 400, 400, 0, Polygon.createRectangle(30, 30) , material );
			chain4.group = 1;
			var chain5:RigidBody = addPolyAsNewBody( 500, 400, 0, Polygon.createRectangle(30, 30) , material );
			chain5.group = 1;
			var jx:PivotJoint = new PivotJoint(chain4, chain5, new Vector2D(450, 400));
			space.addJoint(jx);
			
			var joint1:Joint = new PinJoint(space.defaultStaticBody, chain1, new Vector2D(190,140), new Vector2D( -45, 0));
			space.addJoint(joint1);
			var joint2:Joint = new PinJoint(chain1, chain2, new Vector2D(50, 0), new Vector2D( -50, 0));
			space.addJoint(joint2);
			var joint3:Joint = new PinJoint(chain2, chain3, new Vector2D(50, 0), new Vector2D( -50, 0));
			space.addJoint(joint3);
			var joint4:Joint = new PinJoint(chain3, cirBody, new Vector2D(50, 0), new Vector2D( 0, 0));
			space.addJoint(joint4);			

		}
	}
	
}
