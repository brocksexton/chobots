package org.goverla.controls.wizard.events
{
	import flash.events.Event;

	public class WizardDataChangeEvent extends Event {
		
		private static const EVENT_TYPE : String = "change";
		
		private var _key : Object;
		private var _data : Object;
		
		public function WizardDataChangeEvent(key : Object, data : Object) : void {
			super(CHANGE);
			_key = key;
			_data = data;
		}
		
		public function get key() : Object {
			return _key;
		}

		public function get data() : Object {
			return _data;
		}
		
		
	}
}