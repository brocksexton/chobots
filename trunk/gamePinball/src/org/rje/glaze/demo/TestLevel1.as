package org.rje.glaze.demo {
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.space.Level;
	
	/**
	* ...
	* @author Default
	*/
	public class TestLevel1 extends Level {
		
		public function TestLevel1() {
			super(60, 10, 10);
		}
		
		public override function InitLevelData():void {
			tileData.push(null);
			tileData.push( new Polygon( Polygon.createRectangle(tileFW, tileFW), Vector2D.zeroVect, null ) );
		}
		
	}
	
}