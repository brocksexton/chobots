/* Copyright (c) 2007 Scott Lembcke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package org.rje.glaze.engine.dynamics {

	import flash.display.DisplayObject;
	import org.rje.glaze.engine.math.*;
	import org.rje.glaze.engine.dynamics.*;
	import org.rje.glaze.engine.collision.shapes.*;
	import org.rje.glaze.engine.space.Space;
	
	public class RigidBody {
		
		public var m:Number;			// Body Mass 
		public var m_inv:Number;		// Body inverse mass
		
		public var i:Number;			// Moment of inertia
		public var i_inv:Number;		// Moment of inertia inverse
		
		// Linear components of
		public const p:Vector2D = new Vector2D();			// Position
		public const v:Vector2D = new Vector2D();			// Velocity
		public const f:Vector2D = new Vector2D();			// Force
		public const v_bias:Vector2D = new Vector2D();     // used internally for penetration/joint correction
		
		public var maxVelocityScalar:Number = 1000;
		public var maxVelocityScalarSqr:Number = 1000 * 1000;
		
		public var canSleep:Boolean;
		public var isSleeping:Boolean;
		public var checked:uint;
		
		public var motion:Number = 0.0002;
		public static var bias:Number = 0.99332805041467;
		public static const sleepEpsilon:Number = 0.001;
		
		// Angular components of motion
		public var a:Number;			// angle
		public var w:Number;			// angular velocity
		public var t:Number;			// torque
		public var w_bias:Number;		// used internally for penetration/joint correction
		
		public var space:Space;
		
		//public var arbiters:Array;
		public var arbiters:ArbiterProxy;
		
		//public var rotationLocked:Boolean;
		private var storedInertia:Number = -1;
		
		// Unit length 
		public const rot:Vector2D = new Vector2D(); 
		
		//Collision Type (unused)
		public var collision_type:uint;		
		//Group id
		public var group:uint;
		//Layer bitmask
		public var layers:uint;	
		
		public var collisionProcessingMask:uint = 7;
		
		public var isFixed:Boolean;
		public var isStatic:Boolean;
		
		public var locked:Space;
		
		private var calcMassInertia:Boolean;
		public var memberShapes:Array;
		
		public var bodyID:uint = 0;
		public static var nextBodyID:uint = 0;
		
		public var next:RigidBody;
		public var prev:RigidBody;
		
		public static const STATIC_BODY:int 		= 0;
		public static const DYNAMIC_BODY:int 		= 1;
		public static const FIXED_DYNAMIC_BODY:int  = 2;
		
		public function RigidBody( type:int = DYNAMIC_BODY, m:Number = -1 , i:Number = -1 ) {
			
			bodyID = nextBodyID++;
			
			switch (type) {
				case STATIC_BODY: 			isStatic = true;   isFixed = false; break;
				case DYNAMIC_BODY:			isStatic = false;  isFixed = false; break;
				case FIXED_DYNAMIC_BODY:	isStatic = false;  isFixed = true;  break;
			}
			
			this.calcMassInertia = (m<0) || (i<0);
			
			if (isStatic) {
				this.calcMassInertia = false;
				setMass(Number.POSITIVE_INFINITY);
				setMoment(Number.POSITIVE_INFINITY);
			} else if (!calcMassInertia) {
				setMass(m);
				setMoment(i);
			}
			
			a = w = t = w_bias = 0;
			
			memberShapes = new Array();
			
			arbiters = new ArbiterProxy();
			arbiters.next = arbiters;
			arbiters.prev = arbiters;
			arbiters.sentinel = true;
			
			group  = 0;
			layers = 0xFFFF;
			
			setAngle(0);
			
			collisionProcessingMask = 0;
		}

		public function registerSpace( space:Space ):void {
			this.space = space;
		}

		public function unregisterSpace():void {
			this.space = null;
		}		
		
		public function lock():void {
			if (!space) return;
			locked = space;
			space.removeRigidBody(this);
		}
		
		public function addShape( shape:GeometricShape , updateMI:Boolean = false ):GeometricShape {
			var storedSpace:Space = null;
			
			if (space && !locked) {
				storedSpace = space;
				space.removeRigidBody(this);
			}
			shape.registerBody(this);
			//shape.fixed = this.fixed;
			memberShapes.push(shape);
			if (calcMassInertia) calculateMassInertia();
			if (storedSpace) {
				storedSpace.addRigidBody(this);
			}
			
			return shape;
		}

		public function removeShape( shape:GeometricShape , updateMI:Boolean = false ):void {
			if (space&&!locked) space.removeRigidBody(this);
			var index:int = memberShapes.indexOf(shape);
			if (index >= 0)
				memberShapes.splice(index, 1);
			if (calcMassInertia) calculateMassInertia();
			if (space&&!locked) space.addRigidBody(this);
		}
		
		public function addArbiter( arb:Arbiter ):void {
			var newProxy:ArbiterProxy;
			
			if (ArbiterProxy.arbiterProxyPool) {
				newProxy = ArbiterProxy.arbiterProxyPool;
				ArbiterProxy.arbiterProxyPool = ArbiterProxy.arbiterProxyPool.next;
			} else {
				newProxy = new ArbiterProxy();
			}
			newProxy.arbiter = arb;
			
			newProxy.prev = arbiters;
			newProxy.next = arbiters.next;
			arbiters.next = newProxy;
			newProxy.next.prev = newProxy;
		}

		public function getArbiter( id1:uint , id2:uint ):Arbiter {
			var arbProxy:ArbiterProxy;
			for (arbProxy = arbiters.next; arbProxy.sentinel!=true; arbProxy = arbProxy.next ) {
				if ((arbProxy.arbiter.id1 == id1) && (arbProxy.arbiter.id2 == id2)) return arbProxy.arbiter;
				if ((arbProxy.arbiter.id1 == id2) && (arbProxy.arbiter.id2 == id1)) return arbProxy.arbiter;
			}
			return null;
		}		
		
		public function removeArbiter( arb:Arbiter ):void {
			
			var arbProxy:ArbiterProxy;
			for (arbProxy = arbiters.next; arbProxy.sentinel != true; arbProxy = arbProxy.next ) {
				if (arbProxy.arbiter == arb) {
					arbProxy.prev.next = arbProxy.next;
					arbProxy.next.prev = arbProxy.prev;
					arbProxy.next = ArbiterProxy.arbiterProxyPool;
					ArbiterProxy.arbiterProxyPool = arbProxy;
					return;
				}
			}
		}
		
		public function unlock():void {
			if (!locked) return;
			locked.addRigidBody(this);
			locked = null;			
		}
		
		public function setMass( m:Number):void {
			this.m = m;
			this.m_inv = 1 / m;
		}
		
		public function setMoment( i:Number):void {
			this.i = i;
			this.i_inv = 1 / i;
		}
		
		public function set rotationLocked( value:Boolean ):void {
			if (value) {
				storedInertia = i;
				setMoment(Number.POSITIVE_INFINITY);
			} else {
				setMoment(storedInertia);
				storedInertia = -1;
			}
		}
		
		public function get rotationLocked():Boolean {
			return (storedInertia != -1); 		
		}
		
		public function setMaxVelocity( mv:Number):void {
			if (mv>=0) {
				maxVelocityScalar = mv;
				maxVelocityScalarSqr = maxVelocityScalar * maxVelocityScalar;
			} else {
				maxVelocityScalar = -1;
				maxVelocityScalarSqr = -1;
			}
		}
		
		public function calculateMassInertia():void {
			var newMass:Number = 0;
			var newMomementInertia:Number = 0;
			var shape:GeometricShape;
			for each (shape in memberShapes) {
				newMass += shape.mass;
				newMomementInertia += shape.CalculateInertia( shape.mass , shape.offset );
			}
			setMass(newMass);
			setMoment(newMomementInertia);
		}
		
		public function setAngle( a:Number):void {
			this.a = a % 6.28318530717; //(2*Pi)
			//this.rot.forAngleEquals(this.a);
			rot.x = Math.cos(a);
			rot.y = Math.sin(a);
		}
		
		public function slew(pos:Vector2D, dt:Number):void {
			//cpVect delta = cpvsub(body->p, pos);
			//body->v = cpvmult(delta, 1.0/dt);
		}
		
		public function UpdateVelocity( persistantMasslessForce:Vector2D, force:Vector2D, damping:Number, dt:Number):void {
			v.x = (v.x * damping) + ( (persistantMasslessForce.x + ((force.x + f.x) * m_inv) ) * dt);
			v.y = (v.y * damping) + ( (persistantMasslessForce.y + ((force.y + f.y) * m_inv) ) * dt);
			w = (w * damping) + (t * i_inv * dt);
			checked = 0;
		}
		
		public function UpdatePosition( dt:Number):void {	
			p.x += ((v.x + v_bias.x) * dt);
			p.y += ((v.y + v_bias.y) * dt);
			
			if (maxVelocityScalarSqr>0) {
				var scalarVelocitySqr:Number = v.x * v.x + v.y * v.y;
				
				if (scalarVelocitySqr > maxVelocityScalarSqr) {
					var factor:Number = maxVelocityScalar / Math.sqrt(scalarVelocitySqr);
					v.x *= factor;
					v.y *= factor;
				}
			}
			
			motion = (bias * motion) + ((1 - bias) * (v.x * v.x + v.y * v.y + w * w));
			
			if (motion > (10 * sleepEpsilon)) motion = 10 * sleepEpsilon;
			
			canSleep = motion < sleepEpsilon;
			if (!canSleep) isSleeping = false;

			setAngle( a + ((w + w_bias) * dt));
			
			/*
			if (dispObj) {
				dispObj.x = p.x;
				dispObj.y = p.y;
				dispObj.rotation = a * 180 / Math.PI;
			}
			*/
			
			v_bias.x = v_bias.y = 0;
			w_bias = 0;
		}
		
		public function sleep():void {
			v.x = v.y = w = 0;
			isSleeping = true;
			var arbProxy:ArbiterProxy;
			for (arbProxy = arbiters.next; arbProxy.sentinel != true; arbProxy = arbProxy.next ) {
				arbProxy.arbiter.sleeping = true;
			}
		}	
		
		public function wake( stamp:int ):void {
			motion = 10 * sleepEpsilon;
			canSleep = isSleeping = false;
			var arbProxy:ArbiterProxy;
			for (arbProxy = arbiters.next; arbProxy.sentinel != true; arbProxy = arbProxy.next ) {
				arbProxy.arbiter.sleeping = false;
				arbProxy.arbiter.stamp = stamp;
			}
		}		
		
		public function resetForces():void {
			f.x = f.y = t = 0;
		}
		
		public function ApplyImpulse( j:Vector2D , r:Vector2D ):void {
			if (isSleeping) wake(space.stamp);
			v.x += (j.x * m_inv);
			v.y += (j.y * m_inv);
			w += i_inv * (r.x * j.y - r.y * j.x);
		}
		
		public function ApplyBiasImpulse( j:Vector2D , r:Vector2D ):void {
			if (isSleeping) wake(space.stamp);
			v_bias.x += (j.x * m_inv);
			v_bias.y += (j.y * m_inv);
			w_bias   += i_inv * (r.x * j.y - r.y * j.x);
		}
		
		public function ApplyForces( force:Vector2D , r:Vector2D):void {
			if (isSleeping) wake(space.stamp);
			f.x += force.x;
			f.y += force.y;
			t = r.x * force.y - r.y * force.x;
		}

		public virtual function onStep( stepDT:Number ):void {
			//trace(bodyID+":start " + body.bodyID);
		}		
		
		public virtual function onPhysicsStep( physicsStepDT:Number ):void {
			//trace(bodyID+":start " + body.bodyID);
		}		
		
		public virtual function onStartCollision(body:RigidBody):void {
			//trace(bodyID+":start " + body.bodyID);
		}

		public virtual function onCollision(body:RigidBody):void {
			
		}
		
		public virtual function onEndCollision(body:RigidBody):void {
			//trace(bodyID+":end " + body.bodyID);
		}		
		
	}
	
}
