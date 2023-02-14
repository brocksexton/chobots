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

package {
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.*;
	import flash.ui.Keyboard;
	import flash.system.System;
	import flash.utils.getTimer;
	import org.rje.glaze.engine.dynamics.forces.Spring;
	import flash.utils.ByteArray;
	
	import org.rje.glaze.demo.*;
	import org.rje.glaze.util.*;
	import org.rje.glaze.engine.*;
	import org.rje.glaze.engine.space.*;
	import org.rje.glaze.engine.math.*;
	import org.rje.glaze.engine.dynamics.*;
	import org.rje.glaze.engine.dynamics.joints.*;
	import org.rje.glaze.engine.collision.*;
	import org.rje.glaze.engine.collision.shapes.*;
	
	
	public class Main extends flash.display.Sprite {
		
		public var version:String = "0.3";
		public var lmb:Boolean;
		public var mousePos:Vector2D = new Vector2D();
		public var mouseWheelValue:int = 0;
		public var stageDim:Vector2D;
		public var screenCenter:Vector2D;
		public var space:Space;
		
		public var shiftDown:Boolean = false;
		public var XDown:Boolean = false;
		public var RDown:Boolean = false;
		public var dragging:Boolean = false;
		public var plotGraphics:Boolean = true;
		
		public var dragBody:RigidBody;
		
		public var attract:Boolean = false;
		public var flashy:Boolean = false;
		
		public var storedSpace:ByteArray;
		
		//public var steps:int = 3;
		
		//public var oldTime:int;
		//public var accTime:int;
		//public var pps:int;
		
		public var debug:Boolean = false;
		
		public var demonstration:Demo;
		
		public var fpscounter:FPSCounter;
		
		public var staticSprite:Sprite;
		public var debugSprite:Sprite;
		
		public var upAngle:Number;
		
		public var frameCount:int;
		
		public var bfAlgos:Array = [ "SORTSWEEP" , "SPACIALHASH" , "BRUTEFORCE" ];
		public var bfAlgoSelector:int = 0;
		
		public var lastDemoID:int;
		
		public var spring1:Spring, spring2:Spring, spring3:Spring, spring4:Spring;
		public var springLoc1:Vector2D = new Vector2D(), springLoc2:Vector2D = new Vector2D(), springLoc3:Vector2D = new Vector2D(), springLoc4:Vector2D = new Vector2D();
		
		public function Main():void {

			debugSprite = new Sprite();
			//staticSprite = new Sprite();
			
			stage.scaleMode = "noScale";
			stage.quality = "low";
			
			//Setup event listeners
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyboardDownEvent);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyboardUpEvent);
						
			//Set stage dimension for demos
			stageDim = new Vector2D(600, 600);
			//stageDim = new Vector2D(1200, 1200);
			//this.scaleX = this.scaleY = 0.5;
			screenCenter = stageDim.mult(0.5);
			//Create and add the FPS counter
			fpscounter = new FPSCounter();
			this.addChild(fpscounter);
			
			upAngle = Math.atan2( 0, 1);
			
			//Set inital demo
			setDemo(0);
		
		}
		
		//This is where everthing is called from.  At the moment the physics frame rate is
		//tied to the graphics frame rate.  The physics are update n time per frame where n = the value of 'steps'
		public function onEnterFrame(event:Event):void {
			
			var i:int;
			
			//Clear the stage graphics (everything is drawn here for speed at the moment)
			this.graphics.clear();
			debugSprite.graphics.clear();
			
			//Update the demo, only used if we need to manual adjust a shape; e.g. the orientation of the static body
			demonstration.update(1 / stage.frameRate );
			
			//Step the engine n times.  The higher n, the more accurate things get.
			space.step();
			
			//Draw everything
			if (plotGraphics) {
				var shape:GeometricShape = space.activeShapes;
				while (shape) {
					shape.draw(this.graphics, debug);
					shape = shape.next;
				}
				shape = space.staticShapes;
				while (shape) {
					shape.draw(this.graphics, debug);
					shape = shape.next;
				}
				var joint:Joint = space.joints;
				while (joint) {
					joint.draw(this.graphics, debug);
					joint = joint.next;
				}			
				
				if (RDown) {
					var ray:Ray = new Ray(screenCenter, mousePos);
					ray.returnNormal = true;
					space.castRay(ray);
					this.graphics.moveTo(screenCenter.x, screenCenter.y);
					this.graphics.lineStyle(3, 0xB56A6A);
					this.graphics.lineTo( screenCenter.x + (ray.direction.x * 100) , screenCenter.y + (ray.direction.y * 100) );
					this.graphics.lineTo( screenCenter.x, screenCenter.y);
					if (ray&&ray.intersectInRange) {
						var cPoint:Vector2D = ray.closestIntersectPoint;
						this.graphics.lineStyle(4, 0xF81A14);
						this.graphics.moveTo(cPoint.x - 5, cPoint.y - 5);
						this.graphics.lineTo(cPoint.x + 5, cPoint.y + 5);
						this.graphics.moveTo(cPoint.x + 5, cPoint.y - 5);
						this.graphics.lineTo(cPoint.x - 5, cPoint.y + 5);
						if (ray.returnNormal&&ray.closestIntersectNormal) {
							this.graphics.lineStyle(2, 0x24C507);
							this.graphics.moveTo(cPoint.x , cPoint.y );
							this.graphics.lineTo(cPoint.x +(ray.closestIntersectNormal.x*15), cPoint.y+(ray.closestIntersectNormal.y*15) );
						}
						ray.closestIntersectShape.body.ApplyForces(ray.direction.mult(1000*demonstration.forceFactor), cPoint.minus(ray.closestIntersectShape.body.p));
					}
				}

				
				//If debug, the draw AABB's
				if (debug) {
					var contact:Contact;
					var arbiter:Arbiter = space.arbiters;
					this.graphics.lineStyle(1, 0xFF0000);
					while (arbiter!=null) {
						contact = arbiter.contacts;
						while (contact!=null) {
							graphics.drawRect(contact.p.x - 1, contact.p.y - 1, 2, 2);
							contact = contact.next;
						}
						arbiter = arbiter.next;
					}
					var bodyContact:BodyContact;
					for (bodyContact = space.bodyContacts.next; bodyContact.sentinel != true; bodyContact = bodyContact.next ) {
						this.graphics.moveTo(bodyContact.bodyA.p.x, bodyContact.bodyA.p.y);
						//this.graphics.lineStyle(1, 0xFF0000);
						this.graphics.lineStyle(bodyContact.contactCount, bodyContact.startContact ? 0x00FF00 : 0xFF0000);
						this.graphics.lineTo(bodyContact.bodyB.p.x, bodyContact.bodyB.p.y);
					}
				}
			}
			
			if (attract) {
				var body:RigidBody = space.activeBodies;
				while (body) {
					Forces.LinearAttractor(body, mousePos, 1000 * demonstration.forceFactor);
					body = body.next;
					//Forces.InverseSqrAttractor(body, mousePos, 2000);
				}
			}
			
			if (frameCount % 30) updateInfoString(false);
			
			frameCount++;

		}
		
		//If mouse is down, fire block.
		public function onMouseDown(event:MouseEvent):void {
			lmb = true;	
			
			if (shiftDown) {
				attract = true;
			} else if (XDown) {
				deleteBodyUnderMouse();
			} else {
				fireBlock();
			}
		}
		
		//If mouse is up
		public function onMouseUp(event:MouseEvent):void {
			lmb = false;
			attract = false;
		}
		
		//If mouse is moved
		public function onMouseMove(event:MouseEvent):void {
			mousePos.setTo(event.stageX, event.stageY);
			if (dragging) updateDragSprings();
		}
		
		//If mouse wheel is moved
		public function onMouseWheel(event:MouseEvent):void {
			mouseWheelValue += (event.delta < 0) ? 1 : -1;
		}
		
		public function updateDragSprings():void {
			springLoc1.x = mousePos.x - 20;
			springLoc1.y = mousePos.y - 20;
			springLoc2.x = mousePos.x + 20;
			springLoc2.y = mousePos.y - 20;
			springLoc3.x = mousePos.x + 20;
			springLoc3.y = mousePos.y + 20;
			springLoc4.x = mousePos.x - 20;
			springLoc4.y = mousePos.y + 20;			
		}
		
		//If key is pressed
		public function onKeyboardDownEvent(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.SPACE: 
					debug = !debug; 
					if (debug) 
						this.addChild(debugSprite);
					else
						this.removeChild(debugSprite);
					return;
				//Dump engine info to system clipboard.  Can the be pased into text editor of choice
				case Keyboard.ENTER:		
					bfAlgoSelector++;
					if (bfAlgoSelector == bfAlgos.length) bfAlgoSelector = 0;
					setDemo(lastDemoID);
					return;
				case Keyboard.SHIFT: shiftDown = true; return;
				case 65:
					storedSpace = new ByteArray();
					storedSpace.writeObject(demonstration.space);
					trace(storedSpace.toString());
					break;
				case 66:
					if (storedSpace) {
						storedSpace.position = 0;
						var myObject:Object = storedSpace.readObject();
						demonstration.space = myObject as Space;
					}
					break;
				case 68:
					if (dragging) return;
					var dragShape:GeometricShape = space.getShapeAtPoint(mousePos);
					if (dragShape != null) {
						dragBody = dragShape.body;
						dragging = true; 
						//dragBody.w = 0;
						
						updateDragSprings();
						
						var strength:Number = 500;
						var damping:Number = 50;
						var len:Number = 10;
						
						spring1 = new Spring(dragBody, springLoc1, strength, len, damping);
						spring2 = new Spring(dragBody, springLoc2, strength, len, damping);
						spring3 = new Spring(dragBody, springLoc3, strength, len, damping);
						spring4 = new Spring(dragBody, springLoc4, strength, len, damping);
						
						space.addForce(spring1);
						space.addForce(spring2);
						space.addForce(spring3);
						space.addForce(spring4);
						

					}
					return;
				case 71: plotGraphics = !plotGraphics; return;
				case 82: RDown = true; return;
				case 88: XDown = true; return;
				
				//Set which demo you want
				case 49:/*1*/  setDemo(1); return;
				case 50:/*2*/  setDemo(2); return;
				case 51:/*3*/  setDemo(3); return;
				case 52:/*4*/  setDemo(4); return;
				case 53:/*5*/  setDemo(5); return;
				case 54:/*6*/  setDemo(6); return;
				case 55:/*7*/  setDemo(7); return;
				case 56:/*8*/  setDemo(8); return;
				case 57:/*9*/  setDemo(9); return;
			}
		}

		public function onKeyboardUpEvent(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.SHIFT: shiftDown = false; return;
				case 68: dragging = false; 
						 
						 space.removeForce(spring1);
						 space.removeForce(spring2);
						 space.removeForce(spring3);
						 space.removeForce(spring4);
						 
						 return;
				case 82: RDown = false; return;
				case 88: XDown = false; return;
			}
		}		
		
		//Util function to set demo
		public function setDemo( demoID:int ):void {
			
			lastDemoID = demoID;
			
			var demo:Demo;
			
			switch (demoID) {
				case 0:/*0*/ demo = new TitleDemo(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 1:/*1*/ demo = new DominoPyramid(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 2:/*2*/ demo = new BasicStack(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 3:/*3*/ demo = new PyramidThree(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 4:/*4*/ demo = new BoxPyramidDemo(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 5:/*5*/ demo = new PentagonRain(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 6:/*6*/ demo = new Jumble(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 7:/*7*/ demo = new SegmentDemo(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 8:/*8*/ demo = new JointDemo(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 9:/*9*/ demo = new Spin(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
			}
			
			this.demonstration = demo;
			space = demonstration.demoSpace;
			updateInfoString(true);
			fpscounter.refreshText();
		}
		
		public function updateInfoString(now:Boolean):void {
			fpscounter.userMessage = "\nDemo=" + demonstration.title + "(fps="+space.fps+" pps="+space.pps+ ")\nShapes=" + space.activeShapesCount + "\nBF=" + space.broadphaseCounter.name + "\nCollision (B/N)=" + int(space.broadphaseCounter.mean) + "/" + int(space.narrowphaseCounter.mean);
			if (now) fpscounter.refreshText();
		}
			
		//Fires a block into the scene
		public function fireBlock():void {
			var firePos:Vector2D = stageDim.clone()
			firePos.x += 100;
			firePos.y /= 3;
			
			var projVelocity:Vector2D = mousePos.minus(firePos).normalize().multEquals(800);

			var projectileBody:RigidBody = new RigidBody();
			projectileBody.setMaxVelocity( -1);
			projectileBody.p.copy(firePos);
			projectileBody.v.copy(projVelocity);
			projectileBody.w = 2;
			var material:Material = new Material(0.0, 1, 5);
			projectileBody.addShape(new Polygon(Polygon.createRectangle(20, 20), Vector2D.zeroVect, material));
			
			space.addRigidBody(projectileBody);
		}

		public function deleteBodyUnderMouse():void {
			var shape:GeometricShape = space.getShapeAtPoint(mousePos);
			if (shape != null) 
				space.removeRigidBody(shape.body);
		}		
	}
}