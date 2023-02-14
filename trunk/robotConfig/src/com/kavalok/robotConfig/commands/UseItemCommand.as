package com.kavalok.robotConfig.commands
{
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.robots.Robots;
	
	public class UseItemCommand extends ModuleCommandBase
	{
		private var _item:RobotItemTO;
		private var _position:int;
		
		public function UseItemCommand(item:RobotItemTO, position:int)
		{
			_item = item;
			_position = position;
		}
		
		override public function execute():void
		{
			if (_item.isBaseItem)
				useBaseItem();
			else if (_item.isSpecialItem)
				useSpecialItem();
			else if (_item.isArtifact)
				useArtifact();
				
			configData.updateRobot();
		}
		
		private function useBaseItem():void
		{
			var currentItems:Array = configData.getUsedBaseItems();
			for each (var currentItem:RobotItemTO in currentItems)
			{
				if (currentItem.placement == _item.placement)
					currentItem.unUse();
			}
			useItem();
		}
		
		private function useItem():void
		{
			forceItems();
			_item.useBy(configData.currentRobot.id, _position);
		}
		
		private function useArtifact():void
		{
			forceItems();
			if (configData.getUsedArtifacts().length < Robots.MAX_ARTIFACTS)
				useItem();
		}
		
		private function forceItems():void
		{
			for each (var item:RobotItemTO in configData.items)
			{
				if (item.name == _item.name && item.robotId == configData.currentRobot.id)
					item.unUse();
			}
		}
		
		private function useSpecialItem():void
		{
			if (configData.getUsedSpecialItems().length < Robots.MAX_SPECIAL_ITEMS)
				useItem();
		}
		
	}
}