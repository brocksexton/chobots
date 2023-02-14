package org.goverla.interfaces {

	import org.goverla.interfaces.ICommand;

	public interface IUndoableCommand extends ICommand {
		
		function undo() : void;
	
	}

}