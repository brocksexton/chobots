package com.kavalok.commands
{
	import com.kavalok.events.EventSender;
	
	import flash.utils.Dictionary;
	
	public class AsincMacroCommand implements ICancelableCommand
	{
		private var _completeEvent:EventSender = new EventSender(IAsincCommand);
		private var _commands:Dictionary = new Dictionary();
		private var _executed:Boolean = false;
		
		public function AsincMacroCommand()
		{
			super();
		}
		
		public function add(command:IAsincCommand):void
		{
			_commands[command] = false;
			
			if (_executed)
				executeCommand(command);
		}
		
		public function execute():void
		{
			_executed = true;
			for (var command:Object in _commands)
			{
				executeCommand(IAsincCommand(command));
			}
		}
		
		private function executeCommand(command:IAsincCommand):void
		{
			command.completeEvent.addListener(onCommandComplete);
			command.execute();
		}
		
		private function onCommandComplete(command:IAsincCommand):void
		{
			_commands[command] = true;
			command.completeEvent.removeListener(onCommandComplete);
			for each (var completed:Boolean in _commands)
			{
				if (!completed)
					return;
			}
			_executed = false;
			_completeEvent.sendEvent(this);
		}
		
		public function cancel():void
		{
			for (var command:Object in _commands)
			{
				if (command is ICancelableCommand && !_commands[command])
				{
					ICancelableCommand(command).completeEvent.removeListener(onCommandComplete);
					ICancelableCommand(command).cancel();
				}
			}
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
	}
	
}