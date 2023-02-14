package common.commands
{
	import common.events.EventSender;
	
	public interface IAsincCommand extends ICommand
	{
		function get completeEvent():EventSender;
	}
	
}