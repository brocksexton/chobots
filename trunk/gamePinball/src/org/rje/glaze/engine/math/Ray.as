/**
* ...
* @author Default
* @version 0.1
*/

package org.rje.glaze.engine.math {

	import org.rje.glaze.engine.collision.shapes.*;
	import org.rje.glaze.engine.dynamics.RigidBody;
	
	public class Ray {
		
		public var origin:Vector2D;
		public var target:Vector2D;
		public var direction:Vector2D;

		public var fdirection:Vector2D;
		
		public var castingBody:RigidBody;
		
		public var range:Number;
		public var rangeSqr:Number;
		
		public var endpoint:Vector2D;
		
		public var isSegment:Boolean;
		
		public var returnNormal:Boolean;
	
		public var lastIntersectResult:Boolean;
		public var lastIntersectDistance:Number;
		public var lastIntersectShape:GeometricShape;
		
		public var intersectInRange:Boolean;
		public var closestIntersectDistance:Number;
		public var closestIntersectNormal:Vector2D;
		public var closestIntersectShape:GeometricShape;
		
		public function Ray(origin:Vector2D , target:Vector2D , castingBody:RigidBody = null , range:Number = Number.POSITIVE_INFINITY) {
			
			this.origin = origin;
			this.target = target;
			direction = target.minus(origin).normalize();
			fdirection = direction.abs();
			
			this.castingBody = castingBody;
			closestIntersectDistance = Number.POSITIVE_INFINITY;
			
			if (range < Number.POSITIVE_INFINITY) { 
				isSegment = true;
				endpoint = origin.plus(direction.mult(range));
			}
			
			this.range = range;
			this.rangeSqr = range * range;
		}
		
		public function testShape(shape:GeometricShape):Boolean {
			lastIntersectResult = false;  
			if (!castingBody && shape.body == castingBody) { 
				return false;
			}
			return shape.IntersectRay(this);
		}
		
		public function reportResult( shape:GeometricShape , dist:Number , normal:Vector2D = null ):Boolean {
			
			if (dist>=range) {
				lastIntersectResult = false;
				return false;
			}
			intersectInRange = true;
			lastIntersectResult = true;
			lastIntersectDistance = dist;
			lastIntersectShape = shape;
			
			if (dist < closestIntersectDistance) {
				closestIntersectDistance = dist;
				closestIntersectShape = shape;
				closestIntersectNormal = normal;
			}
			
			return true;
		}
		
		public function get lastIntersectPoint():Vector2D {
			return new Vector2D(origin.x + (direction.x * lastIntersectDistance), origin.y + (direction.y * lastIntersectDistance));
		}
		
		public function get closestIntersectPoint():Vector2D {
			return new Vector2D(origin.x + (direction.x * closestIntersectDistance), origin.y + (direction.y * closestIntersectDistance));
		}
		
		/*
		public function intersectAABB( aabb:AABB ):Boolean {
			var Dx:Number = origin.x - aabb.xCenter;
			var Dy:Number = origin.y - aabb.yCenter;

			//if ( range && (Dx*Dx+Dy*Dy)>rangeSqr ) return false
			if ((((Dx<0)?-Dx:Dx) > aabb.xExtent) && ((Dx * direction.x) >= 0)) return false;
			if ((((Dy<0)?-Dy:Dy) > aabb.yExtent) && ((Dy * direction.y) >= 0)) return false;	
			var f:Number = direction.x * Dy - direction.y * Dx;	
			if (f < 0) f = -f;
			if (f > (aabb.xExtent * fdirection.y + aabb.yExtent * fdirection.x) ) return false;
			return true;
		}
		*/
		
	}
	
}
