package com.kavalok.robotConfig.view
{
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.robots.RobotItemSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.TypeRequirement;
	
	import robotConfig.McArtifactBack;
	import robotConfig.McArtifactDropzone;
	import robotConfig.McArtifacts;
	
	public class ArtifactsView extends DropableView
	{
		private var _content:McArtifacts;
		
		public function ArtifactsView(content:McArtifacts)
		{
			super(_content = content);
		}
		
		override protected function getDropSrites():Array
		{
			return GraphUtils.getAllChildren(_content, new TypeRequirement(McArtifactDropzone), false);
		}
		
		override protected function getItems():Array
		{
			return configData.getUsedArtifacts();
		}
		
		override protected function createItemSprite(item:RobotItemTO):RobotItemSprite
		{
			var sprite:RobotItemSprite = new RobotItemSprite(item);
			sprite.useView = false;
			sprite.buttonMode = true;
			sprite.background = new McArtifactBack();
			sprite.boundsMargin = 4;
			
			return sprite;
		}

	}
}