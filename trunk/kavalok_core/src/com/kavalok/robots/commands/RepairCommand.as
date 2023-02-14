package com.kavalok.robots.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.events.EventSender;
	import com.kavalok.interfaces.ICommand;
	import com.kavalok.robots.Robot;
	import com.kavalok.robots.RobotUtil;
	import com.kavalok.utils.Strings;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.services.RobotService;

	public class RepairCommand implements ICommand
	{
		private var _completeEvent:EventSender = new EventSender();
		private var _robot:Robot;
		
		public function RepairCommand(robot:Robot)
		{
			_robot = robot;
		}

		public function execute():void
		{
			var price:int = RobotUtil.getRepairCost(_robot.level);
			if (Global.charManager.money < price)
			{
				Dialogs.showOkDialog(Global.messages.noMoney);
			}
			else
			{
				var message:String = Strings.substitute(
					Global.resourceBundles.robots.messages.repairMessage,
					price);
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog(message);
				dialog.yes.addListener(onYesClick);
			}
		}
		
		private function onYesClick():void
		{
			Global.isLocked = true;
			new RobotService(onComplete).repairRobot(_robot.id);
		}
		
		public function onComplete(result:Object):void
		{
			Global.isLocked = false;
			_completeEvent.sendEvent();
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
	}
}