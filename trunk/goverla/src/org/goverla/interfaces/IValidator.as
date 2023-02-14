package org.goverla.interfaces {
	
	import flash.events.IEventDispatcher;
	
	/**
	 * Defines the properties and methods that objects that participate in View Forms validation must implement.  
	 * @author Tyutyunnyk Eugene
	 */
	public interface IValidator extends IEventDispatcher {
	
		/**
		 * When implemented by a class, evaluates the condition it checks and upates the IValidator.IsValid property.  
		 */
		function validate() : void;
		
		/**
		 * When implemented by a class, gets the error message text generated when the condition being validated fails.  
		 */
		function get errorMessage() : String;
	
		/**
		 * When implemented by a class, sets the error message text generated when the condition being validated fails.  
		 */      
		function set errorMessage(text : String) : void;
	      
		/**
		 *  When implemented by a class, gets a value indicating whether the user-entered content in the specified control passes validation. 
		 */
		function get isValid() : Boolean;
		
		function get enabled() : Boolean;
		
		function set enabled(enabled : Boolean) : void;
		
	}
	
}