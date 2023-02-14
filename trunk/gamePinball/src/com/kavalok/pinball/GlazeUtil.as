package com.kavalok.pinball
{
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.dynamics.Material;
	import org.rje.glaze.engine.math.Vector2D;
	
	public class GlazeUtil
	{
		public static function getPolygon(displayObject : DisplayObject, localPoints : Array, material : Material = null, offset : Boolean = true) : Polygon
		{
			var verts : Array = [];
			
			var center : Point = GraphUtils.transformCoords(new Point(), displayObject, Global.root);
			
			for each(var point : Point in localPoints)
			{
				var globalPoint : Point = GraphUtils.transformCoords(point.clone(), displayObject, Global.root);
				verts.push(new Vector2D(globalPoint.x - center.x, globalPoint.y - center.y));
			}
			var offsetVector : Vector2D = offset ? new Vector2D(center.x, center.y) : new Vector2D();
			return new Polygon(verts, offsetVector, material);
		}

	}
}