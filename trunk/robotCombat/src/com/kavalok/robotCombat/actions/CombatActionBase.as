package com.kavalok.robotCombat.actions
{
	import com.kavalok.dto.robot.CombatResultTO;
	import com.kavalok.robotCombat.CombatPlayer;
	import com.kavalok.robotCombat.commands.ModuleCommandBase;
	import com.kavalok.robots.RobotModel;
	
	import flash.geom.Point;
	
	public class CombatActionBase extends ModuleCommandBase
	{
		public var source:CombatPlayer;
		public var target:CombatPlayer;
		
		public function CombatActionBase()
		{
			super();
		}
		
		public function get result():CombatResultTO
		{
			return source.result;
		}
		
		public function get sourceModel():RobotModel
		{
			 return mainView.getRobotModel(source.userId);
		}
		
		public function get targetModel():RobotModel
		{
			 return mainView.getRobotModel(target.userId);
		}
		
		public function get sourceTextPosition():Point
		{
			 return mainView.getTextPosition(source.userId);
		}
		
		public function get targetTextPosition():Point
		{
			 return mainView.getTextPosition(target.userId);
		}
	}
}