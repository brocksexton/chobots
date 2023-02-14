package com.kavalok.robotCombat.view
{
	import assets.combat.McRobotItemRect;
	
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.robots.RobotItemSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.TypeRequirement;
	
	import flash.display.Sprite;
	
	public class ArtifactsView
	{
		private var _container:Sprite;
		private var _rectangles:Array;
		
		public function ArtifactsView(container:Sprite)
		{
			_container = container;
			_container.cacheAsBitmap = true;
			
			_rectangles = GraphUtils.getAllChildren(container,
				new TypeRequirement(McRobotItemRect), false);
			_rectangles.sortOn('x', Array.NUMERIC);	
			
			for each (var rect:Sprite in _rectangles)
			{
				rect.visible = false;
			}
		}
		
		public function setItems(items:Array):void
		{
			for (var i:int = 0; i < items.length; i++)
			{
				var item:RobotItemTO = items[i];
				var rect:McRobotItemRect = _rectangles[i];
				
				var sprite:RobotItemSprite = new RobotItemSprite(item);
				sprite.useView = false;
				sprite.background = new McRobotItemRect();
				sprite.boundsMargin = 2;
				
				_container.addChild(sprite);
				GraphUtils.setCoords(sprite, rect);
			}
		}

	}
}