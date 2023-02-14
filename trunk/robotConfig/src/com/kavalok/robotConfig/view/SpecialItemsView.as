package com.kavalok.robotConfig.view
{
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.robotConfig.DropZone;
	import com.kavalok.robots.RobotItemSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.TypeRequirement;
	
	import flash.display.Sprite;
	
	import robotConfig.McSpecialItemDropZone;
	import robotConfig.McSpecialItems;
	
	public class SpecialItemsView extends DropableView
	{
		private var _content:McSpecialItems;
		
		public function SpecialItemsView(content:McSpecialItems)
		{
			super(_content = content);
		}
		
		override protected function getDropSrites():Array
		{
			return GraphUtils.getAllChildren(_content,
				 new TypeRequirement(McSpecialItemDropZone), false);
		}
		
		override protected function getItems():Array
		{
			return configData.getUsedSpecialItems();
		}
		
		override protected function placeSprite(sprite:Sprite, dropzone:DropZone):void
		{
			sprite.x = dropzone.content.x - 0.5 * sprite.width;
			sprite.y = dropzone.content.y - 0.5 * sprite.height;
		}
		
		override protected function createItemSprite(item:RobotItemTO):RobotItemSprite
		{
			var sprite:RobotItemSprite = new RobotItemSprite(item);
			sprite.useView = false;
			sprite.buttonMode = true;
			sprite.loaderView.width = 60;
			sprite.loaderView.height = 60;
			sprite.background = GraphUtils.createRectSprite(60, 60, 0, 0);
			
			return sprite;
		}

	}
}	