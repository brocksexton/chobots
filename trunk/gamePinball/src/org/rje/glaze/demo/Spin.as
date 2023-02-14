package org.rje.glaze.demo {
	import org.rje.glaze.engine.collision.shapes.GeometricShape;
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.collision.shapes.Segment;
	import org.rje.glaze.engine.dynamics.Material;
	import org.rje.glaze.engine.dynamics.RigidBody;
	import org.rje.glaze.engine.math.Vector2D;
	
	/**
	* ...
	* @author Default
	*/
	public class Spin extends Demo {
		
		public var spinBox:RigidBody;
		
		public function Spin(fps:int, dim:Vector2D, bfAlgo:String) {
			super(dim,bfAlgo,20,fps,180);
			space.masslessForce.setTo(0, 600);
			forceFactor = 0.1;
			title = "Spin";
		}
				
		public override function initSpace():void {

			spinBox = new RigidBody( RigidBody.FIXED_DYNAMIC_BODY, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
			var len:Number = 400;
			var width:Number = 25;
			var mat1:Material = new Material(1.0, 1.0, 1);
			spinBox.addShape( new Polygon( Polygon.createRectangle(len, width) , new Vector2D(0, -len/2), mat1 ));
			spinBox.addShape( new Polygon( Polygon.createRectangle(len, width) , new Vector2D(0,  len/2), mat1 ));
			spinBox.addShape( new Polygon( Polygon.createRectangle(width, len) , new Vector2D(-len/2, 0), mat1 ));
			spinBox.addShape( new Polygon( Polygon.createRectangle(width, len) , new Vector2D( len/2, 0), mat1 ));
			
			spinBox.p.setTo(300, 300);
			spinBox.w = 0.5;
			space.addRigidBody(spinBox);
			
			for (var i:int = 0; i < 4; i++) {
				spinBox.memberShapes[i].fillColour = 0xA2CA97;
			}
			
			var mat2:Material = new Material(0.0, 0.1, 1);
			var boxShape:Array = Polygon.createRectangle(30, 60);
			for (var j:int = 0; j < 5; j++) {
				for (var k:int = 0; k < 5; k++) {
					addPolyAsNewBody(220 + (j * 31), 150 + (k * 61), 0, boxShape, mat2);
				}
			}
		}
		
		public override function update(dt:Number):void {
		}
		
	}
	
}