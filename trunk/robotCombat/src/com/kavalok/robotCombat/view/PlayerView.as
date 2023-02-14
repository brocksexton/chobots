package com.kavalok.robotCombat.view
{
	import com.kavalok.gameplay.controls.ProgressBar;
	import com.kavalok.robotCombat.CombatPlayer;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import gs.TweenLite;
	import gs.easing.Expo;
	
	public class PlayerView
	{
		public var player:CombatPlayer;
		public var charView:CharView;
		public var artifactView:ArtifactsView;
		public var robotView:RobotView;
		public var energyBar:ProgressBar;
		
		private var _textPosition:Sprite;
		
		public function PlayerView(player:CombatPlayer)
		{
			this.player = player;
		}
		
		public function setTextPosition(position:Sprite):void
		{
			 _textPosition = position;
			 _textPosition.visible = false;
		}
		
		public function get textPosition():Point
		{
			 return GraphUtils.objToPoint(_textPosition);
		}
		
		public function applyData():void
		{
			charView.setChar(player.char);
			artifactView.setItems(player.robot.artifacts);
			robotView.setRobot(player.robot);
			refresh();
		}
		
		public function refresh():void
		{
			var value:Number = player.robot.energy / player.robot.maxEnergy; 
			TweenLite.to(energyBar, 1.0, {value: value, ease:Expo.easeOut});
			robotView.refresh();
		}
	}
}