package org.goverla.interfaces {

	import flash.events.IEventDispatcher;

	public interface IEditable extends IEventDispatcher {
		
		function get editable() : Boolean;
		
		function set editable(editable : Boolean) : void;
		
		function get saving() : Boolean;
		
		function edit(showSaveAndCancelButtons : Boolean = true) : void;
		
		function view() : void;
		
		function save() : void;
		
		function cancel() : void;
		
	}

}