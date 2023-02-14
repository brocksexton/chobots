package com.kavalok.robots
{
	import com.kavalok.URLHelper;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.controls.ProgressBar;
	import com.kavalok.utils.GraphUtils;
	
	import flash.geom.ColorTransform;
	
	public class RobotItemSprite extends ResourceSprite
	{
		private var _item:RobotItemTO;
		private var _bar:ProgressBar;
		
		public function RobotItemSprite(item:RobotItemTO, autoLoad:Boolean = true)
		{
			_item = item;
			super(URLHelper.robotItemURL(_item.name), 'McStuff', autoLoad);
			this.readyEvent.addListener(onReady);
		}
		
		public function onReady(sender:ResourceSprite):void
		{
			if (_item.isBaseItem)
				aplyColor();
			refresh();
		}
		
		private function aplyColor():void
		{
			var colorInfo:Object = GraphUtils.toRGB(_item.color);
			content.transform.colorTransform = new ColorTransform(
					colorInfo.r/255.0, colorInfo.g/255.0, colorInfo.b/255.0);
		}
		
		public function refresh():void
		{
			ToolTips.registerObject(this, getToolTip());
			if ((_item.useCount > 0 || _item.expirationDate) && background)
				refreshBar();
		}
		
		private function refreshBar():void
		{
			if (!_bar)
			{
				_bar  = new ProgressBar(new McRobotItemBar());
				_bar.content.x = boundsMargin;
				_bar.content.y = background.height - 2 * boundsMargin + 1;
				_bar.content.width = background.width - 2 * boundsMargin - 1;
				addChild(_bar.content);
			}
			
			if (_item.useCount > 0)
				_bar.value = Number(_item.remains) / Number(_item.useCount);
			else
				_bar.value = Number(_item.daysLeft) / Number(_item.lifeTime);
			
		}
		
		private function getToolTip():String
		{
			return new RobotItemInfoSprite(_item).htmlText;
		}
		
		public function get item():RobotItemTO { return _item; }

	}
}