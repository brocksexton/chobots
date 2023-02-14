package org.goverla.controls.wizard.interfaces {
	import org.goverla.events.EventSender;
	
	public interface IWizardNavigation {
		
		function get next() : EventSender;
		function get back() : EventSender;

		function set nextEnabled(value : Boolean) : void;
		function set backEnabled(value : Boolean) : void;
		
	}
}