package com.kavalok.robotConfig.commands
{
	import com.kavalok.commands.AsincMacroCommand;
	import com.kavalok.commands.IAsincCommand;
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.robot.RobotTO;
	import com.kavalok.robotConfig.view.MainView;
	import com.kavalok.robots.Robot;
	
	import flash.display.Sprite;
	
	public class StartupCommand extends ModuleCommandBase
	{
		private var _robotsCommand:GetRobotsCommand;
		private var _itemsCommand:GettItemsCommand;
		private var _root:Sprite;
		
		public function StartupCommand(root:Sprite)
		{
			_root = root;
			super();
		}
		
		override public function execute():void
		{
			var getDataCommand:AsincMacroCommand = new AsincMacroCommand();
			getDataCommand.add(_robotsCommand =  new GetRobotsCommand());
			getDataCommand.add(_itemsCommand = new GettItemsCommand());
			getDataCommand.completeEvent.addListener(onDataComplete);
			getDataCommand.execute();
		}
		
		private function onDataComplete(sender:IAsincCommand):void
		{
			applyData();
			
			if (configData.robots.length > 0)
				createView();
			else
				showMessage();
				
			dispathComplete();
		}
		
		private function showMessage():void
		{
			var dialog:DialogOkView = Dialogs.showOkDialog(bundle.messages.haveNotRobot, true, null, false);
			dialog.ok.addListener(onDialogClose);
		}
		
		private function onDialogClose():void
		{
			RobotConfig.instance.closeModule();
		}
		
		private function applyData():void
		{
			for each (var robotTO:RobotTO in _robotsCommand.result)
			{
				configData.robots.push(new Robot(robotTO));
			}
			configData.items = _itemsCommand.result;
			configData.currentRobot = configData.activeRobot;
			configData.changed = false;
		}
		
		private function createView():void
		{
			configData.root = _root;
			var view:MainView = new MainView();
			configData.root.addChild(view.content);
		}
		
	}
}