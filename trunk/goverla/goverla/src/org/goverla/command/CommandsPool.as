package org.goverla.command {
	
	import flash.events.Event;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.collections.ListCollectionViewIterator;
	import org.goverla.errors.IllegalStateError;
	import org.goverla.events.DefaultEvent;
	import org.goverla.events.ProgressEvent;
	import org.goverla.interfaces.IAsynchronousCommand;

	public class CommandsPool extends AsynchronousCommandBase {
		
		public var haltOnError : Boolean = false;
		
		[Bindable(event="progress")]
		public function get progressValue() : Number {
			return _progress;
		}
		
		[Bindable]
		public function get processing() : Boolean {
			return _processing;
		}

		protected function set processing(value : Boolean) : void {
			_processing = value;
		}
		
		public function get currentCommand() : IAsynchronousCommand {
			return _currentCommand;
		}
		
		public function CommandsPool() {
			super();
		}
		
		public function clear() : void {
			if (processing) {
				throw new IllegalStateError("Cannot clear while processing");
			} else {
				_commands.removeAll();
			}
		}

		public function add(command : IAsynchronousCommand) : void {
			if (processing) {
				throw new IllegalStateError("Cannot add command while processing");
			} else {
				_commands.addItem(command);
			}
		}
		
		public function remove(command : IAsynchronousCommand) : void {
			if(command != currentCommand) {
				_commands.removeItem(command);
			} else {
				throw new IllegalStateError("Cannot remove currently executing command");
			}
		}

		override public function execute() : void {
			_progress = 0;
			dispatchProgress();
			if (processing) {
				throw new IllegalStateError("Pool is executing");
			} else {
				processing = true;
				_iterator = new ListCollectionViewIterator(_commands);
				processNext();
			}
		}
		
		private function processNext() : void {
			if (_iterator.hasNext()) {
				_currentCommand = IAsynchronousCommand(_iterator.next());
				_currentCommand.success.addListener(onCommandSuccess);
				_currentCommand.error.addListener(onCommandError);
				_currentCommand.progress.addListener(onCommandProgress);
				_currentCommand.execute();
			} else {
				processing = false;
				_currentCommand = null;
				success.sendEvent(new DefaultEvent());
			}
		}
		
		private function onCommandSuccess(event : Event) : void {
			updateProgress();
			removeCommandListeners();
			processNext();
		}

		private function onCommandError(event : Event) : void {
			updateProgress();
			removeCommandListeners();
			if (haltOnError) {
				processing = false;
				_currentCommand = null;
				error.sendEvent(new DefaultEvent());
			} else {
				processNext();
			}
		}
		
		private function updateProgress() : void {
			_progress = (_commands.getItemIndex(_currentCommand) + 1) / _commands.length;
			dispatchProgress();
		}
		
		private function dispatchProgress() : void {
			progress.sendEvent(new ProgressEvent(progressValue));
			dispatchEvent(new ProgressEvent(progressValue));
		}
		

		private function onCommandProgress(event : ProgressEvent) : void {
			_progress = (_commands.getItemIndex(_currentCommand) + event.progress) / _commands.length;
			dispatchProgress();
		}
		
		private function removeCommandListeners() : void {
			_currentCommand.success.removeListener(onCommandSuccess);
			_currentCommand.error.removeListener(onCommandError);
			_currentCommand.progress.removeListener(onCommandProgress);
		}
		
		private var _currentCommand : IAsynchronousCommand;
		
		private var _progress : Number = 0;
		
		private var _processing : Boolean = false;
		
		private var _commands : ArrayList = new ArrayList();
		
		private var _iterator : ListCollectionViewIterator;
		
	}
	
}