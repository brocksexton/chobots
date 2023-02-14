package com.kavalok.robotConfig.view
{
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.robotConfig.commands.CloseCommand;
	import com.kavalok.robotConfig.view.robotselect.RobotComboView;
	import com.kavalok.robots.Robot;
	import com.kavalok.robots.commands.RepairCommand;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.TypeRequirement;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import robotConfig.McRobotConfig;
	
	public class MainView extends ModuleViewBase
	{
		static private var _instance:MainView;
		
		static public function get instance():MainView
		{
			 return _instance;
		}
		
		private var _content:McRobotConfig;
		
		private var _robotsCombo:RobotComboView;
		private var _itemsFrame:ItemsFrameView;
		private var _artifacts:ArtifactsView;
		private var _specialItems:SpecialItemsView;
		private var _robot:RobotView;
		private var _parameters:ParametersView;
		
		public function MainView()
		{
			_instance = this;
			initialize();
			initTextFields();
			initButtons();
			
			configData.changeEvent.addListener(refresh);
			
			refresh();
		}
		
		private function initialize():void
		{
			_content = new McRobotConfig();
			
			_robotsCombo = new RobotComboView(_content.robotCombo, configData.robots, 'localizedName');
			_robotsCombo.changeEvent.addListener(onRobotSelect);
			
			_robot = new RobotView(_content.robotClip);
			_itemsFrame = new ItemsFrameView(_content.itemsFrameClip);
			_artifacts = new ArtifactsView(_content.artifactsClip);
			_specialItems = new SpecialItemsView(_content.specialItemsClip);
			_parameters = new ParametersView(_content);
			
			ToolTips.registerObject(_content.attackIcon, 'attack', ResourceBundles.ROBOTS);
			ToolTips.registerObject(_content.defenceIcon, 'defence', ResourceBundles.ROBOTS);
			ToolTips.registerObject(_content.accuracyIcon, 'accuracy', ResourceBundles.ROBOTS);
			ToolTips.registerObject(_content.mobilityIcon, 'mobility', ResourceBundles.ROBOTS);
			ToolTips.registerObject(_content.energyBar, 'energy', ResourceBundles.ROBOTS);
			ToolTips.registerObject(_content.experienceBar, 'experience', ResourceBundles.ROBOTS);
			
			
			bundle.registerButton(_content.activateButton, 'activate');
			bundle.registerButton(_content.repairButton, 'repair');
			
			_content.activateButton.addEventListener(MouseEvent.CLICK, onActivateClick);
			_content.repairButton.addEventListener(MouseEvent.CLICK, onRepairClick);
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			new CloseCommand().execute();
		}
		
		private function onRepairClick(e:MouseEvent):void
		{
			var command:RepairCommand = new RepairCommand(configData.currentRobot);
			command.completeEvent.addListener(onRepairComplete);
			command.execute();
		}
		
		private function onRepairComplete():void
		{
			configData.currentRobot.energy = configData.currentRobot.maxEnergy;
			refresh(); 
		}
		
		private function onActivateClick(e:MouseEvent):void
		{
			configData.activeRobot = configData.currentRobot;
		}
		
		private function onRobotSelect():void
		{
			configData.currentRobot = _robotsCombo.currentItem as Robot;
		}
		
		private function refresh():void
		{
			_robotsCombo.currentItem = configData.currentRobot;
			_itemsFrame.refresh();
			_artifacts.refresh();
			_specialItems.refresh();
			_robot.refresh();
			_parameters.refresh();
			
			GraphUtils.setBtnEnabled(_content.repairButton, configData.currentRobot.needRepair);
		}
		
		private function initTextFields():void
		{
			var fields:Array = GraphUtils.getAllChildren(_content, 
				new TypeRequirement(TextField), false);
			
			for each (var field:TextField in fields)
			{
				RobotConfig.instance.initTextField(field);	
			}
		}
		
		private function initButtons():void
		{
			var buttons:Array = GraphUtils.getAllChildren(_content, 
				new TypeRequirement(SimpleButton), false);
			
			for each (var button:SimpleButton in buttons)
			{
				RobotConfig.instance.initButton(button);
			}
		}
		
		public function get content():Sprite { return _content; }
		public function get artifacts():ArtifactsView { return _artifacts; }
		public function get specialItems():SpecialItemsView { return _specialItems; }
		public function get robot():RobotView { return _robot; }

	}
}