package org.goverla.controls.wizard {
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Button;
	
	import org.goverla.controls.wizard.interfaces.IWizardNavigation;
	import org.goverla.events.EventSender;

	public class WizardNavigationBase extends HBox implements IWizardNavigation {
		
		public var nextButton : Button;
		public var backButton : Button;

		private var _back : EventSender = new EventSender();
		private var _next : EventSender = new EventSender();
		
		
		public function get next() : EventSender {
			return _back;
		}
		
		public function get back() : EventSender {
			return _next;
		}

		public function set nextEnabled(value : Boolean) : void {
			nextButton.enabled = value;
		}

		public function set backEnabled(value : Boolean) : void {
			backButton.enabled = value;
		}
		
		protected function onBackClick(event : MouseEvent) : void {
			back.sendEvent(event);
		}

		protected function onNextClick(event : MouseEvent) : void {
			next.sendEvent(event);
		}
	}
}