package com.kavalok.robotCombat.commands
{
	import com.kavalok.Global;
	import com.kavalok.commands.IAsincCommand;
	import com.kavalok.events.EventSender;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.robotCombat.Combat;
	import com.kavalok.robotCombat.view.MainView;
	
	public class ModuleCommandBase implements IAsincCommand
	{
		private var _completeEvent:EventSender = new EventSender(ModuleCommandBase);
		
		public function ModuleCommandBase()
		{
		}
		
		public function execute():void
		{
		}
		
		public function get completeEvent():EventSender
		{
			 return _completeEvent;
		}
		
		protected function dispathComplete():void
		{
			_completeEvent.sendEvent(this);
		}
		
		protected function get combat():Combat
		{
			return Combat.instance;	
		}
		
		protected function get mainView():MainView
		{
			return MainView.instance;
		}
		
		public function get bundle():ResourceBundle
		{
			 return Global.resourceBundles.robots;
		}

	}
}