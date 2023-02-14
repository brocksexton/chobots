package org.goverla.controls.wizard.common
{
	import org.goverla.collections.HashMap;
	import org.goverla.controls.wizard.events.WizardDataChangeEvent;
	import org.goverla.events.EventSender;

	public class WizardDataMap extends HashMap {
		
		public var signupType : String;
		
		private var _change : EventSender = new EventSender();
		
		public function get change() : EventSender {
			return _change;
		}

		override public function addItem(key : Object, value : Object) : void {
			super.addItem(key, value);
			change.sendEvent(new WizardDataChangeEvent(key, value));
		}
	}
}