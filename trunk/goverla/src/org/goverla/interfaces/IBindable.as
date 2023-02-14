package org.goverla.interfaces {

	import flash.events.IEventDispatcher;
	
	import org.goverla.collections.AbstractFormDataProvider;

	public interface IBindable extends IEventDispatcher {
		
		function get formDataProvider() : AbstractFormDataProvider;
		
		function set formDataProvider(dataProvider : AbstractFormDataProvider) : void;
		
		function get fieldName() : String;
		
		function set fieldName(fieldName : String) : void;
		
		function get value() : Object;
		
		function set value(value : Object) : void;
		
	}

}