package org.goverla.events {

	import flash.events.Event;
	
	public class CreditCardTypeChangedEvent extends Event {
		
		private static var CREDIT_CARD_TYPE_CHANGED_EVENT_TYPE : String = "cardTypeChanged";
		
		public function CreditCardTypeChangedEvent() {
			super(CREDIT_CARD_TYPE_CHANGED_EVENT_TYPE);
		}
	
	}
	
}