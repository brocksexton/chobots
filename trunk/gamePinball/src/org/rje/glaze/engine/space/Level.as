package org.rje.glaze.engine.space {
	import org.rje.glaze.engine.collision.shapes.AABB;
	
	/**
	* ...
	* @author Default
	*/
	public class Level {
		
		public var tileFW:int;
		public var gridSize:Number;
		public var width:int;
		public var height:int;
		
		public var worldBoundary:AABB;
		
		public var tileData:Array;
		public var levelData:Array;
		
		public function Level( tileFW:Number , width:int, height:int ) {
			this.tileFW = tileFW;
			this.gridSize = 1 / tileFW;
			this.width = width;
			this.height = height;
			
			tileData  = new Array();
			levelData = new Array();
			
			InitLevelData();
			RegisterLevelData();
		}
		
		public function InitLevelData():void {
			
		}
		
		public function RegisterLevelData():void {
			
		}
		
		
		
	}
	
}