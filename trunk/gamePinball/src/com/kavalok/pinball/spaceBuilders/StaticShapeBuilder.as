package com.kavalok.pinball.spaceBuilders
{
	import com.kavalok.pinball.GlazeUtil;
	import com.kavalok.pinball.space.EventSpace;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.rje.glaze.engine.collision.shapes.GeometricShape;
	import org.rje.glaze.engine.dynamics.Material;
	
	public class StaticShapeBuilder implements ISpaceBuilder
	{
		private static const LOCAL_SQUARE_COORDS : Array = [new Point(-50, -50), new Point(-50, 50), new Point(50, 50), new Point(50, -50)];

		protected var material : Material;
		private var _type : Class;
		private var _color : uint;
		
		public function StaticShapeBuilder(type : Class, material : Material, color : uint = 0)
		{
			_type = type;
			this.material = material;
			_color = color;
		}

		public function process(displayObject : DisplayObject, space : EventSpace, game : GamePinball) : void
		{
			if(displayObject is _type)
			{
				var staticShape : GeometricShape = createShape(displayObject);
				staticShape.fillColour = _color;
				space.defaultStaticBody.addShape(staticShape);
			}
		}
		
		protected function createShape(displayObject : DisplayObject) : GeometricShape
		{
			return GlazeUtil.getPolygon(displayObject, LOCAL_SQUARE_COORDS, material);
		}
		
	}
}