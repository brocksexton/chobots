/**
* ...
* @author Default
* @version 0.1
*/

package org.rje.glaze.engine.collision.shapes {

	import org.rje.glaze.engine.math.*;
	
	public class Tile extends Polygon {
		
		public var size:Number;
		public var halfSize:Number;
		
		public function Tile( vertsList:Array , size:Number, rotation:Vector2D , material:Material = null ) {

			this.size = size;
			this.halfSize = size / 2;
			
			for (var i:int = 0; i < vertsList.length; i++) {
				var v:Vector2D = vertsList[i];
				v.x = (v.x * rotation.x - v.y * rotation.y);				
				v.y = (v.x * rotation.y + v.y * rotation.x);
			}

			super(vertsList, Vector2D.zeroVect, material);
			
		}
		
		public function PositionTile( p:Vector2D ):void {
			
			aabb.l = p.x - halfSize;
			aabb.r = p.x + halfSize;
			aabb.t = p.y - halfSize;
			aabb.b = p.y + halfSize;
			
			var v:Vector2D = verts;
			var tv:Vector2D = tVerts;
			while (v) {
				tv.x = p.x + v.x;
				tv.y = p.y + v.y;
				v = v.next;
				tv = tv.next;
			}
			
			var a:Axis = axes;
			var ta:Axis = tAxes;
			while (a) {
				ta.d   = (p.x * a.n.x + p.y * a.n.y) + a.d;
				a = a.next;
				ta = ta.next;
			}
		}
		
	}
	
}
