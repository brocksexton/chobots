package org.goverla.command {
	
	import flash.events.EventDispatcher;
	
	import org.goverla.events.EventSender;
	import org.goverla.events.ProgressEvent;
	import org.goverla.interfaces.IAsynchronousCommand;

	public class AsynchronousCommandBase extends EventDispatcher implements IAsynchronousCommand {
		
		public function get success() : EventSender {
			return _success;
		}
		
		public function get error() : EventSender {
			return _error;
		}
		
		public function get progress() : EventSender {
			return _progress;
		}

		public function AsynchronousCommandBase() {
			super();
		}

		public function execute() : void {}
		
		private var _success : EventSender = new EventSender();
		
		private var _error : EventSender = new EventSender();
		
		private var _progress : EventSender = new EventSender(ProgressEvent);
		
	}
	
}