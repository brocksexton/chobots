package org.rje.glaze.engine.space {
	
	import org.rje.glaze.engine.collision.shapes.AABB;
	import org.rje.glaze.engine.collision.shapes.GeometricShape;
	import org.rje.glaze.engine.math.Ray;
	import org.rje.glaze.engine.math.Vector2D;
	
	/**
	* ...
	* @author Default
	*/
	public class BruteForceSpace extends Space {
		
		public function BruteForceSpace( fps:int , pps:int , worldBoundary:AABB = null ) {
			super(fps,pps,worldBoundary);
			broadphaseCounter.name += " Brute Force";
		}
		
		public override function broadPhase():void {
			var s1:GeometricShape = activeShapes;
			var s2:GeometricShape, s3:GeometricShape;
			while (s1) {
				s2 = s1.next;
				while (s2) {
					broadphaseCounter.counter++;
					if (s2.aabb.l <= s1.aabb.r) {
						if (s1.aabb.l <= s2.aabb.r) {
							if (s2.aabb.t <= s1.aabb.b) {
								if (s1.aabb.t <= s2.aabb.b) {
									narrowPhase(s1,s2);
								}
							}
						}
					}
					s2 = s2.next;
				}
				s3 = staticShapes;
				while (s3) {
					broadphaseCounter.counter++;
					if (s3.aabb.l <= s1.aabb.r) {
						if (s1.aabb.l <= s3.aabb.r) {
							if (s3.aabb.t <= s1.aabb.b) {
								if (s1.aabb.t <= s3.aabb.b) {
									narrowPhase(s1,s3);
								}
							}
						}
					}
					s3 = s3.next;
				}
				s1 = s1.next;
			}
			broadphaseCounter.endCycle();
		}
		
		public override function sync():void {
		}
		
		public override function castRay( ray:Ray ):Boolean {
			var shape:GeometricShape = activeShapes;
			while (shape) {
				ray.testShape(shape);
				shape = shape.next;
			}
			
			shape = staticShapes;
			while (shape) {
				ray.testShape(shape);
				shape = shape.next;
			}
			
			return ray.intersectInRange;
		}
		
		public override function getShapeAtPoint( point:Vector2D ):GeometricShape {
			var shape:GeometricShape = activeShapes;
			while (shape) {
				if (shape.ContainsPoint(point)) {
					return shape;
				}
				shape = shape.next;
			}
			
			shape = staticShapes;
			while (shape) {
				if (shape.ContainsPoint(point)) {
					return shape;
				}
				shape = shape.next;
			}
			
			return null;
		}		
		
	}
	
}