package com.kavalok.robotCombat.view
{
	import com.kavalok.robots.Robot;
	import com.kavalok.robots.RobotModel;
	import com.kavalok.robots.RobotModels;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class RobotView extends ModuleViewBase
	{
		private var _container:Sprite;
		private var _model:RobotModel;
		private var _levelField:TextField;
		private var _energyField:TextField;
		private var _robot:Robot;
		
		public function RobotView(container:Sprite, levelField:TextField, energyField:TextField)
		{
			_container = container;
			_levelField = levelField;
			_energyField = energyField;
			
			initTextField(_levelField);
			initTextField(_energyField);
			
			GraphUtils.removeChildren(_container);
		}
		
		public function setRobot(robot:Robot):void
		{
			_robot = robot;
			_levelField.text = bundle.messages.level + ' ' + robot.level;
			
			_model = new RobotModel(robot);
			_model.setModel(RobotModels.DEFAULT);
			_container.addChild(_model);
			
			refresh();
		}
		
		public function refresh():void
		{
			_energyField.text = String(_robot.energy);
		}
		
		public function get model():RobotModel
		{
			 return _model;
		}
		

	}
}