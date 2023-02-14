package org.goverla.command {

	import flash.events.EventDispatcher;
	
	import org.goverla.collections.Stack;
	import org.goverla.errors.IllegalStateError;
	import org.goverla.events.CommandHistoryChangeEvent;
	import org.goverla.interfaces.IUndoableCommand;

	public class CommandHistory extends EventDispatcher {

		[Bindable(event="commandHistoryChange")]
		public function get canUndo() : Boolean {
			return !_executedCommands.isEmpty();
		}
		
		[Bindable(event="commandHistoryChange")]
		public function get canRedo() : Boolean {
			return !_undoneCommands.isEmpty();
		}
		
		public function CommandHistory() {
			_executedCommands = new Stack();
			_undoneCommands = new Stack();
		}
		
		public function execute(command : IUndoableCommand) : void {
			doExecute(command);
			_undoneCommands = new Stack();
			dispatchEvent(new CommandHistoryChangeEvent());
		}
		
		public function addCommand(command : IUndoableCommand) : void {
			_executedCommands.enqueue(command);
			_undoneCommands = new Stack();
			dispatchEvent(new CommandHistoryChangeEvent());
		}
		
		public function undo() : void {
			if (canUndo) {
				var command : IUndoableCommand = IUndoableCommand(_executedCommands.dequeue());
				command.undo();
				_undoneCommands.enqueue(command);
			} else {
				throw new IllegalStateError("Nothing to undo");
			}
			dispatchEvent(new CommandHistoryChangeEvent());
		}
	
		public function redo() : void {
			if (canRedo) {
				var command : IUndoableCommand = IUndoableCommand(_undoneCommands.dequeue());
				doExecute(command);
			} else {
				throw new IllegalStateError("Nothing to redo");
			}
			dispatchEvent(new CommandHistoryChangeEvent());
		}
		
		private function doExecute(command : IUndoableCommand) : void {
			command.execute();
			_executedCommands.enqueue(command);
		}
		
		private var _executedCommands : Stack;

		private var _undoneCommands : Stack;
		
	}

}