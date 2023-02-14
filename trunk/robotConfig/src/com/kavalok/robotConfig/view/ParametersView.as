package com.kavalok.robotConfig.view
{
	import com.kavalok.gameplay.controls.ProgressBar;
	import com.kavalok.robots.Robot;
	import com.kavalok.robots.RobotUtil;
	import com.kavalok.utils.GraphUtils;
	
	import flash.text.TextField;
	
	import robotConfig.McRobotConfig;
	
	public class ParametersView extends ModuleViewBase
	{
		private var _content:McRobotConfig;
		private var _energyBar:ProgressBar;
		private var _experienceBar:ProgressBar;
		
		public function ParametersView(content:McRobotConfig)
		{
			_content = content;
			
			_energyBar = new ProgressBar(_content.energyBar);
			_experienceBar = new ProgressBar(_content.experienceBar);
		}
		
		public function refresh():void
		{
			var robot:Robot = configData.currentRobot;
			var energy:int = Math.min(robot.energy, robot.maxEnergy);
			
			applyProperty(_content.attackField, robot.baseAttack, robot.additionalAttack);
			applyProperty(_content.defenceField, robot.baseDefence, robot.additionalDefence);
			applyProperty(_content.accuracyField, robot.baseAccuracy, robot.additionalAccuracy);
			applyProperty(_content.mobilityField, robot.baseMobility, robot.additionalMobility);
			
			_content.activeField.text = (robot.active)
				? bundle.messages['active']
				:  bundle.messages['inactive'];
			GraphUtils.setBtnEnabled(_content.activateButton, !robot.active);
			
			_content.energyField.text = bundle.messages.energy
				+ ': '
				+ String(energy)
				+ ' / '
				+ String(robot.maxEnergy);
			_energyBar.value = energy / robot.maxEnergy;
			
			var currentExp:int = robot.experience;
			var prevExp:Number = RobotUtil.getExperience(robot.level);
			var nextExp:Number = RobotUtil.getExperience(robot.level + 1);
			
			_content.levelField.text = bundle.messages.level
				+ ': '
				+ String(robot.level);
			
			_content.experienceField.text = bundle.messages.experience
				+ ': '
				+ String(robot.experience)
				+ ' / '
				+ String(nextExp);
			
			_experienceBar.value = (currentExp - prevExp) / (nextExp - prevExp);
		}
		
		private function applyProperty(field:TextField, baseSum:int, additioonalSum:int):void
		{
			field.text = '' + baseSum;
			
			if (additioonalSum > 0)
				field.appendText('+' + additioonalSum);
			else if (additioonalSum < 0) 
				field.appendText('-' + additioonalSum);
		}
	}
}