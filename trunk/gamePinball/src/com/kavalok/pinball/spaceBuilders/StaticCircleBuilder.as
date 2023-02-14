package com.kavalok.pinball.spaceBuilders
{
	import flash.display.DisplayObject;
	
	import org.rje.glaze.engine.collision.shapes.Circle;
	import org.rje.glaze.engine.collision.shapes.GeometricShape;
	import org.rje.glaze.engine.dynamics.Material;
	import org.rje.glaze.engine.math.Vector2D;

	public class StaticCircleBuilder extends StaticShapeBuilder
	{
		public function StaticCircleBuilder(type:Class, material:Material, color:uint=0)
		{
			super(type, material, color);
		}
		
		override protected function createShape(displayObject:DisplayObject):GeometricShape
		{
			return new Circle(displayObject.width / 2, new Vector2D(displayObject.x, displayObject.y), material);
		}
	}
}