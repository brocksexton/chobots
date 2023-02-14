package org.rje.glaze.engine.space {
	import org.rje.glaze.engine.collision.shapes.Circle;
	import org.rje.glaze.engine.collision.shapes.Polygon;
	
	/**
	* ...
	* @author Default
	*/
	public class TileSpace extends SortAndSweepSpace {
		
		public var level:Level;
		
		public function TileSpace( fps:int , pps:int , level:Level ) {
			super(fps, pps, worldBoundary);
			this.level = level;
			broadphaseCounter.name += " Tile";
		}
		
		public override function sync():void {
			super.sync();
		}
		
		public override function broadPhase():void {
			
			var x:uint , y:uint;
			var l:int, r:int , b:int, t:int;
			
			var shape:GeometricShape = activeShapes;

			var gridsize:Number = level.gridSize;
			
			while (shape) {
				l = int(shape.aabb.l*gridsize);
				r = int(shape.aabb.r*gridsize);
				b = int(shape.aabb.b*gridsize);
				t = int(shape.aabb.t*gridsize);
				for (x = l; x <= r ; x++) {
					for (j = t; y <= b ; y++) {
						var tileID:int = int(y * _width + x);
						var id:uint = level.levelData[int(tileID)];
						if (id == 0) continue;
						var hash:uint = (tileID << 12) | shape.shapeID;
						var pairArbiter:Arbiter = shapeContactDict[hash];
						var pairFound:Boolean = true;
						if (!pairArbiter) {
							if (Arbiter.arbiterPool == null) 
								Arbiter.arbiterPool = pairArbiter = new Arbiter();
							else
								pairArbiter = Arbiter.arbiterPool;
							pairArbiter.assign(s1, s2, stamp);
							pairFound = false;
						} 
						var collided:Boolean;
						collided = (shape.shapeType == GeometricShape.POLYGON_SHAPE) ? poly2tile( shape as Polygon , tile, x, y, pairArbiter ) : circle2tile( shape as Circle , tile, x, y, pairArbiter );

					}
				}
				shape = shape.next;
			}			
			
			super.broadPhase();
		}	
		
		
		public function poly2tile( shape1:Polygon , tile:Polygon, tileX:int, tileY:int, arb:Arbiter ):Boolean {
			
			var v:Vector2D;
			var vertValOnAxis:Number;
			var minValOnAxis:Number;
			
			var minPen1:Number = -4294967296;// Number.MAX_VALUE;
			var minAxis1:Axis;
			
			var first:Boolean = true;
			
			//First, project shape 2 vertices onto shape 1 axes & find MSA
			var a:Axis = shape1.tAxes;
			while (a) {
				
				//Inline code
				//result = shape2.valueOnAxis(a.n,a.d);
				minValOnAxis = 4294967296;// Number.MAX_VALUE;
				v = tile.tVerts;
				while (v) { 
					
					vertValOnAxis = (a.n.x * ( v.x + tileX )  + a.n.y * ( v.y + tileY) ) - a.d;
					if (first||v.flag) {
						v.flag = vertValOnAxis <= 0;
					}
					if (vertValOnAxis < minValOnAxis) minValOnAxis = vertValOnAxis;
					v = v.next;
				}
				//End inline
				
				//No penetration on this axis, early out
				if (minValOnAxis > 0) return false; 
				if (minValOnAxis > minPen1) {
					minPen1 = minValOnAxis;
					minAxis1 = a;
				}
				first = false;
				a = a.next;
			}

			var minPen2:Number = -4294967296;// Number.MAX_VALUE;
			var minAxis2:Axis;
			first = true;

			//Second, project shape 1 vertices onto shape 2 axes & find MSA
			a = shape2.tAxes;
			while (a) {
				//Inline code
				//result = shape1.valueOnAxis(a.n, a.d);
				minValOnAxis = 4294967296;// Number.MAX_VALUE;
				v = shape1.tVerts;
				while (v) { 
					
					vertValOnAxis = (a.n.x * v.x + a.n.y * v.y) - ((tileX * a.n.x + tileY * a.n.y) + a.d);
					if (first||v.flag) {
						v.flag = vertValOnAxis <= 0;
					} 
					if (vertValOnAxis < minValOnAxis) minValOnAxis = vertValOnAxis;
					v = v.next;
				}
				//minValOnAxis -= a.d;
				//End inline
				
				//No penetration on this axis, early out
				if (minValOnAxis > 0) return false;
				if (minValOnAxis > minPen2) {
					minPen2 = minValOnAxis;
					minAxis2 = a;
				}
				first = false;
				a = a.next;
			}

			//Process contact points
			
			var axis:Axis;
			var nCoef:Number;
			var dist:Number;
			
			if (minPen1 > minPen2) {
				axis = minAxis1;
				nCoef = 1;
				dist = minPen1;
			} else {
				axis = minAxis2;
				nCoef = -1;
				dist = minPen2;				
			}
			
			var i:int = 0;
			var c:int = 0;
			v = shape1.tVerts;
			while (v) {
				if (v.flag) {
					arb.injectContact(v.x, v.y, axis.n.x, axis.n.y, nCoef, dist, (shape1.shapeID << 8) | i );// (shape1.shapeID * 3344921057) ^ (i * 3344921057) );
					if (++c > 1) return true;  //never more than 2 support points?
				}
				i++;
				v = v.next;
			}
			i = 0;
			v = shape2.tVerts;
			while (v) {
				if (v.flag) {
					arb.injectContact( v.x, v.y, axis.n.x, axis.n.y, nCoef, dist, (shape2.shapeID << 8) | i ); // (shape2.shapeID * 3344921057) ^ (i * 3344921057)) ;
					if (++c > 1) return true; //never more than 2 support points?
				}
				i++;
				v = v.next;
			}
		
			return true;
		}
			
		public function poly2poly( shape1:Polygon, tile:Polygon, tileX:int, tileY:int, arb:Arbiter ):Boolean {
			
		}
		
	}
	
}