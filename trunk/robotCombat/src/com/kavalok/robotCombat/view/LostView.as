package com.kavalok.robotCombat.view
{
	import assets.combat.McLostScreen;
	
	import com.kavalok.Global;
	import com.kavalok.robotCombat.commands.QuitCommand;
	import com.kavalok.robots.commands.RepairCommand;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	import gs.easing.Expo;
	
	public class LostView extends FinishViewBase
	{
		private var _content:McLostScreen = new McLostScreen();
		
		public function LostView()
		{
			super(_content);
			initButton(repairButton);
			bundle.registerButton(repairButton, 'repair'); 
			repairButton.addEventListener(MouseEvent.CLICK, onRepairClick);
		}
		
		override protected function get captionText():String
		{
			return bundle.messages.youLose;
		}
		
		public function get repairButton():SimpleButton { return _content.repairButton; }
		
		private function onRepairClick(e:MouseEvent):void
		{
			var command:RepairCommand = new RepairCommand(combat.myPlayer.robot);
			command.completeEvent.addListener(onRepairComplete);
			command.execute();
		}
		
		private function onRepairComplete():void
		{
			new QuitCommand().execute();
		}
		
	}
}