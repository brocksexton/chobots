package common.commands
{
	import common.events.EventSender;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class AsincMacroCommand implements ICancelableCommand
	{
		private var _completeEvent:EventSender = new EventSender(this);
		private var _commands:Dictionary = new Dictionary();
		
		public function AsincMacroCommand()
		{
			super();
		}
		
		public function add(command:IAsincCommand):void
		{
			_commands[command] = false;
		}
		
		public function execute():void
		{
			for (var command:Object in _commands)
			{
				IAsincCommand(command).completeEvent.addListener(onCommandComplete);
				IAsincCommand(command).execute();
			}
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
			_completeEvent.sendEvent();
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
		
		public function get commands():Dictionary { return _commands; }
		
	}
	
}