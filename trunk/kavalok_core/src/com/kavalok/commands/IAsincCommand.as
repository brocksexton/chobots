package com.kavalok.commands
{
	import com.kavalok.events.EventSender;
	import com.kavalok.interfaces.ICommand;
	
	public interface IAsincCommand extends ICommand
	{
		function get completeEvent():EventSender;
	}
	
}