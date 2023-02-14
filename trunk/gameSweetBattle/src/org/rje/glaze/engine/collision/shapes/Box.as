/**
* ...
* @author Default
* @version 0.1
*/

package org.rje.glaze.engine.collision.shapes {

	public class Box extends Polygon {
		
		public var halfsize:Vector2D;
		
		public function Box( halfsize:Vector2D , offset:Vector2D , material:Material = null ) {

			this.halfsize = halfsize;
			
			var rect:Array = new Array();
			rect.push( new Vector2D( -halfsize.x, -halfsize.y) );
			rect.push( new Vector2D( -halfsize.x,  halfsize.y) );
			rect.push( new Vector2D(  halfsize.x,  halfsize.y) );
			rect.push( new Vector2D(  halfsize.x, -halfsize.y) );	
			
			super(rect, offset, material);
		}
		
		public override function valueOnAxis( n:Vector2D , d:Number ):Number {	
			var aa:Number = n.x * tAxes.n.x + n.y * tAxes.n.y;
			var ab:Number = n.x * tAxes.next.n.x + n.y * tAxes.next.n.y
			if (aa < 0) aa = -aa;
			if (ab < 0) ab = -ab;
			return ((halfsize.x * aa) + (halfsize.y * ab)) - d;
		}
		
	}
	
}
