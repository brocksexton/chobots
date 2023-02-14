package org.goverla.interfaces {
	
	import org.goverla.events.EventSender;

	public interface IAsynchronousCommand extends ICommand {

		function get success() : EventSender;
		
		function get error() : EventSender;
		
		function get progress() : EventSender;

	}

}