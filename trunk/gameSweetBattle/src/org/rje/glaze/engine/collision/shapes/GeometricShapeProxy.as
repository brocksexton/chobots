package org.rje.glaze.engine.collision.shapes {
	
	/**
	* ...
	* @author Default
	*/
	public class GeometricShapeProxy {
		
		public var shape:GeometricShape
		
		public var next:GeometricShapeProxy;
		public var prev:GeometricShapeProxy;
		
		public function GeometricShapeProxy() {
			
		}
		
	}
	
}