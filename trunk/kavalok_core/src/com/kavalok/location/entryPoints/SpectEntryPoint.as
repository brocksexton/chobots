package com.kavalok.location.entryPoints
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class SpectEntryPoint extends SpriteEntryPoint
	{
		private var _positionArea:Sprite;
		private var _target:Sprite;
		
		public function SpectEntryPoint(clickArea:InteractiveObject, positionArea:Sprite, target:Sprite)
		{
			_positionArea = positionArea;
			_positionArea.visible = false;
			_target = target;
			
			super(clickArea);
		}
		
		override public function get charPosition():Point
		{
			var point:Point = GraphUtils.getRandomZonePoint(_positionArea);
			GraphUtils.transformCoords(point, _positionArea, _target);
			
			return point;
		}
	}
}