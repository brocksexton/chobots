/**
* ...
* @author Default
* @version 0.1
*/

package org.rje.glaze.engine.space {
	
	import org.rje.glaze.engine.collision.shapes.*;
	import org.rje.glaze.engine.math.Ray;
	import org.rje.glaze.engine.math.Vector2D;

	public class SpacialHashSpace extends Space {
		
		public var numBuckets:int;
		public var gridsize:Number;
		
		public var activeBuckets:Array;
		public var staticBuckets:Array;
									   
		public const hashValue1:uint = 2185031351;//2185031351
		public const hashValue2:uint = 4232417593;
		
		public function SpacialHashSpace( fps:int , pps:int , worldBoundary:AABB = null , numBuckets:int = 257 , gridsize:Number = 50 ) {
			super(fps,pps,worldBoundary);
			broadphaseCounter.name += " Spacial Hash";
			this.numBuckets = numBuckets;
			this.gridsize = 1/gridsize;
			activeBuckets = new Array(numBuckets);
			staticBuckets = new Array(numBuckets);
			
			for (var i:int = 0; i < numBuckets; i++) {
				activeBuckets[i] = new Array();
				staticBuckets[i] = new Array();
			}
		}
		
		public function hashShapes( shapes:GeometricShape , bucket:Array ):void {
			for (var z:int = 0; z < numBuckets; z++) {
				bucket[z].length = 0;
				broadphaseCounter.counter++;
			}			
			var i:uint , j:uint;
			var l:int, r:int , b:int, t:int;
			
			var shape:GeometricShape = shapes;
			var thisBucket:Array;
			while (shape) {
				l = int(shape.aabb.l*gridsize);
				r = int(shape.aabb.r*gridsize);
				b = int(shape.aabb.b*gridsize);
				t = int(shape.aabb.t*gridsize);
				for (i = l; i <= r ; i++) {
					for (j = t; j <= b ; j++) {
						var hash:uint = (i * hashValue1)^(j * hashValue2);
						hash %= numBuckets;
						thisBucket = bucket[int(hash)]
						thisBucket.push(shape);
						broadphaseCounter.counter++;
					}
				}
				shape = shape.next;
			}			
		}
		
		public override function sync():void {
			hashShapes(staticShapes, staticBuckets);
		}
		
		public override function broadPhase():void {

			hashShapes(activeShapes, activeBuckets);
			
			var i:int , j:int, k:int, z:int;
			
			var s1:GeometricShape;
			var s2:GeometricShape;
			var s3:GeometricShape;

			for (z = 0; z < numBuckets; z++) {
				
				var thisActiveBucket:Array = activeBuckets[z];
				var thisActiveBucketLen:int = thisActiveBucket.length;
				var thisStaticBucket:Array = staticBuckets[z];
				var thisStaticBucketLen:int = thisStaticBucket.length;
				
				for (i = 0; i < thisActiveBucketLen; i++) {
					s1 = thisActiveBucket[i];
					
					for (j = i + 1; j < thisActiveBucketLen; j++) {
						s2 = thisActiveBucket[j];
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
					}
					
					for (k = 0; k < thisStaticBucketLen; k++) {
						s3 = thisStaticBucket[k];
						if (s3.aabb.l <= s1.aabb.r) {
							if (s1.aabb.l <= s3.aabb.r) {
								if (s3.aabb.t <= s1.aabb.b) {
									if (s1.aabb.t <= s3.aabb.b) {
										narrowPhase(s1,s3);
									}
								}
							}
						}
					}
					
				}
			}
			broadphaseCounter.endCycle();
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
