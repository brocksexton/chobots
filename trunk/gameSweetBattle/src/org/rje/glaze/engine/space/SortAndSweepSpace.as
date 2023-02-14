/**
* ...
* @author Default
* @version 0.1
*/

package org.rje.glaze.engine.space {

	import org.rje.glaze.engine.collision.shapes.*;
	import org.rje.glaze.engine.math.Ray;
	import org.rje.glaze.engine.math.Vector2D;
	
	public class SortAndSweepSpace extends Space {
		
		public function SortAndSweepSpace( fps:int , pps:int , worldBoundary:AABB = null ) {
			super(fps,pps,worldBoundary);
			broadphaseCounter.name += " Sort&Sweep";
		}
		
		public function Sort(head:GeometricShape):GeometricShape {
			if (!head) return null;
			var h:GeometricShape = head, p:GeometricShape, n:GeometricShape, m:GeometricShape, i:GeometricShape;
			n = h.next;
			while (n) {
				m = n.next;
				p = n.prev;
				broadphaseCounter.counter++;
				
				if (p.aabb.t > n.aabb.t) {
					i = p;
					
					while (i.prev) {
						broadphaseCounter.counter++;
						if (i.prev.aabb.t > n.aabb.t)
							i = i.prev;
						else
							break;
					}
					if (m) {
						p.next = m;
						m.prev = p;
					} else
						p.next = null;
					
					if (i == h) {
						n.prev = null;
						n.next = i;
						
						i.prev = n;
						h = n;
					} else {
						n.prev = i.prev;
						i.prev.next = n;
						
						n.next = i;
						i.prev = n;
					}
				}
				n = m;
			}
			return h;
		}
		
		public override function broadPhase():void {
			
			activeShapes = Sort(activeShapes);	
			
			var shape1:GeometricShape = activeShapes;
			var shape2:GeometricShape;
			var shape3:GeometricShape = staticShapes;
			var shape4:GeometricShape;
			
			while (shape1) {
				shape2 = shape1.next;
				while (shape2) {
					broadphaseCounter.counter++;
					if (shape2.aabb.t > shape1.aabb.b) break;
					if (shape1.aabb.l <= shape2.aabb.r) {
						if (shape1.aabb.r >= shape2.aabb.l) {
							narrowPhase(shape1, shape2);
						}
					}
					shape2 = shape2.next;
				}	
				
				while (shape3) {
					broadphaseCounter.counter++;
					if (shape3.aabb.t > shape1.aabb.b) break;
					if (shape3.aabb.t <= shape1.aabb.b) {
						if (shape1.aabb.t <= shape3.aabb.b) {
							break;
						}
					}
					shape3 = shape3.next;
				}
				
				shape4 = shape3;
				while (shape4) {
					broadphaseCounter.counter++;
					if (shape4.aabb.t > shape1.aabb.b) break;
					if (shape1.aabb.l <= shape4.aabb.r) {
						if (shape1.aabb.r >= shape4.aabb.l) {
							narrowPhase(shape1, shape4);
						}
					}
					shape4 = shape4.next;					
				}				
				shape1 = shape1.next;
			}

			broadphaseCounter.endCycle();
		}
		
		public override function sync():void {
			staticShapes = Sort(staticShapes);
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
		
		/*
		public override function castRay( ray:Ray ):Boolean {
			var rayDirDown:Boolean = ray.direction.y > 0;
			var lastShape:GeometricShape = findClosestShape( ray.origin, activeShapes);
			if (rayDirDown) {
				
			}
			return ray.intersectInRange;
		}
		
		public function findClosestShape( origin:Vector2D, head:GeometricShape ):GeometricShape {
			var shape:GeometricShape = head;
			var lastshape:GeometricShape;
			while (head) {
				if (shape.aabb.t > origin.y) return shape;
				lastshape = shape;
				shape = shape.next;
			}
			return lastshape;
		}
		*/
	}
	
}
