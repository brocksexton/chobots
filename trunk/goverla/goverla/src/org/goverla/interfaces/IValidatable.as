package org.goverla.interfaces {

	import flash.events.IEventDispatcher;

	public interface IValidatable extends IEventDispatcher {
		
		function get valid() : Boolean;
		
		function get performingRemoteValidation() : Boolean;
		
	}

}