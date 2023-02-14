package org.goverla.controls.validators {

	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import org.goverla.collections.HashMap;
	import org.goverla.constants.MetadataNames;
	import org.goverla.controls.validators.common.ErrorMessages;
	import org.goverla.controls.validators.common.UIControlsDefaultValidationProperty;
	import org.goverla.events.ValidatorEvent;
	import org.goverla.interfaces.IValidator;
	import org.goverla.utils.Objects;
	import org.goverla.utils.ReflectUtil;
	import org.goverla.utils.Strings;
	
	/**
	 * Serves as the abstract base class for validation controls.  
	 * @author Tyutyunnyk Eugene
	 */
	internal class BaseValidator extends UIComponent implements IValidator {
	
		public static function hasProperty(component : Object, propertyName : String) : Boolean {
			return ReflectUtil.getPropertiesByInstance(component).contains(propertyName);
		}
		
		private static var _controlsErrorString : HashMap = new HashMap();
	
		/**
		 * Gets the input control to validate.  
		 */
		public function get controlToValidate() : String {
			return _controlToValidate;
		}
		
		/**
		 * Sets the input control to validate.  
		 */
		public function set controlToValidate(id : String) : void {
			_controlToValidate = id;
		}
	
		/**
		 *  Gets a value that indicates whether the validation control is enabled.  
		 */
		[ChangeEvent("enabledChange")]
		public override function get enabled() : Boolean {
			return _enabled;
		}
		
		/**
		 * Sets a value that indicates whether the validation control is enabled.  
		 */
		public override function set enabled(enabled : Boolean) : void {
			_enabled = enabled;
			
			if (!enabled) {
				validate();
			}
			
			dispatchEvent(new ValidatorEvent(ValidatorEvent.ENABLED_CHANGE));
		}
	
		public function get propertyToValidate() : String {
			if (!Objects.isSet(_propertyToValidate) && Objects.isSet(_controlToValidate)) {
				_propertyToValidate = UIControlsDefaultValidationProperty.getPropertyByControlInstance(document[_controlToValidate]);
			}
	
			return _propertyToValidate;
		}
		
		public function set propertyToValidate(name : String) : void {
			_propertyToValidate = name;
		}
		
		/**
		 * Sets the text for the error message.  
		 */
		public function set errorMessage(text : String) : void {
			_errorMessage = text;
		}
	
		/**
		 * Gets the text for the error message.  
		 */
		public function get errorMessage() : String {
			return _errorMessage;
		}
	
		/**
		 * Gets a value that indicates whether the associated input control passes validation. 
		 */
		[Bindable(event="isValidChange")]
		public function get isValid() : Boolean {
			_isValid = evaluateIsValid();
			return _isValid;
		}		
		
		protected function get isCreationComplete() : Boolean {
			return _isCreationComplete;
		}
		
		/**
		 * Gets a value that indicates whether the control specified by the 
		 * BaseValidator.ControlToValidate property is a valid control.
		 * 
		 * @exception No value is specified in the BaseValidator.ControlToValidate property.  
		 * -or- The input control specified by the BaseValidator.ControlToValidate property 
		 * is not found on the page.   
		 */
		protected function get propertiesValid() : Boolean {
	        if (!_propertiesChecked) {
				_propertiesValid = controlPropertiesValid();
				_propertiesChecked = true;
	        }
	        
	        return _propertiesValid;
		}
		
		protected function get controlErrorString() : String {
			if (propertiesValid) {
				return UIComponent(document[controlToValidate]).errorString;
			} else {
				return null;
			}
		}
		
		protected function set controlErrorString(text : String) : void {
			if (propertiesValid) {
				UIComponent(document[controlToValidate]).errorString = text;
			}
		}
		
		private function get controlErrorList() : ArrayCollection {
			return ArrayCollection(_controlsErrorString.getItem(document[_controlToValidate]));
		}		
		
		public function BaseValidator() {
			super();
			_enabled = true;
			_isValid = true;
			_propertiesChecked = false;
			_propertiesValid = true;
			_errorMessage = "";
			_isCreationComplete = false;
		
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
	
		/**
		 * Performs validation on the associated input control and 
		 * updates the BaseValidator.IsValid property.  
		 */
		public function validate() : void {
			if (_isCreationComplete) {
				var previousIsValid : Boolean = _isValid;
				
				if (!_enabled) {
				    _isValid = true;
				    clearControlErrorString();
				} else {
					_propertiesChecked = false;
					if (!propertiesValid) {
						_isValid = true;
					} else {
						_isValid = evaluateIsValid();
					}
					
					// Makes the error string evaluations only after validator state changed
					if (previousIsValid != _isValid) {
						dispatchEvent(new ValidatorEvent(ValidatorEvent.IS_VALID_CHANGE));
						evaluateControlErrorString();
					}
				}
			}
		}
		
		protected function onCreationComplete(event : Object) : void {
			_isCreationComplete = true;
			setDefaultErrorMessage();
			if (propertiesValid) {
				appendEventListeners(UIComponent(document[controlToValidate]));
			}
			_controlsErrorString.addItem(document[controlToValidate], new ArrayCollection());
		}
		
		protected function onControlChange(event : Object) : void {
			validate();
		}
		
		protected function onControlFocusLost(event : Object) : void {
			validate();
		}
		
		/**
		 * Sets the default error message if user not set the another one  
		 */	
		protected function setDefaultErrorMessage() : void {
			if (Strings.isBlank(errorMessage)) {
				errorMessage = ErrorMessages.FIELD_NOT_VALID;
			}		
		}
		
		/**
		 * When overridden in a derived class, this method contains the code to determine 
		 * whether the value in the input control is valid.
		 * 
		 * @return true if the value in the input control is valid; otherwise, false.  
		 */
		protected function evaluateIsValid() : Boolean {
			return true;
		}
		
		/**
		 * Helper function that determines whether the control specified by 
		 * the BaseValidator.ControlToValidate property is a valid control.
		 * 
		 * @return true if the control specified by the BaseValidator.ControlToValidate 
		 *  property is a valid control; otherwise, false.
		 *  
		 * @exception No value is specified for the BaseValidator.ControlToValidate property. 
		 * -or- The input control specified by the BaseValidator.ControlToValidate property 
		 * is not found on the page.  
		 * -or- The input control specified by the BaseValidator.ControlToValidate property 
		 * does not have a ValidationProperty attribute associated with it; therefore, 
		 * it cannot be validated with a validation control.    
		 */
		protected function controlPropertiesValid() : Boolean {
			var controlID : String = controlToValidate;
			if (controlID.length == 0) {
				throw new Error(StringUtil.substitute("The ControlToValidate property of '{0}' cannot be blank.", id));
			}
			checkControlValidationProperty(controlID, "controlToValidate");
			return true;
		}
		
		/**
		 *  Helper function that verifies whether the specified control is on the page and 
		 *  contains validation properties.
		 *  
		 *  @param name: The control to verify. 
		 *  @param propertyName: Provides additional text to describe the source of the exception, 
		 *  if an exception is thrown from using this method.
		 *  
		 *  @exception The specified control is not found.  
		 *  -or- The specified control does not have a ValidationProperty attribute associated with it; therefore, 
		 *  it cannot be validated with a validation control.   
		 */
		protected function checkControlValidationProperty(name : String, propertyName : String) : void {
			var uiComponent : UIComponent = document[name];
			if (!Objects.isSet(uiComponent)) {
				throw new Error(StringUtil.substitute("Unable to find control id '{0}' referenced by the '{1}' property of '{2}'.", name, propertyName, id));
			}
	
			var hasValidationProperty: Boolean = BaseValidator.hasProperty(uiComponent, propertyToValidate);
			if (!hasValidationProperty) {
				throw new Error(StringUtil.substitute("Control '{0}' referenced by the {1} property of '{2}' cannot be validated.", name, propertyName, id));
			}	      
		}
		
		/**
		 * Gets the value associated with the specified input control.
		 * @param name The name of the input control to get the value from.
		 * @return The value associated with the specified input control. 
		 */
		protected function getControlValidationValue(name : String, propertyName : String = null) : Object {
			var result : Object = null;
			
			var uiComponent : UIComponent = UIComponent(document[name]);
			if (uiComponent != null) {
				if (propertyName == null) {
					propertyName = propertyToValidate;
				}
				
				var hasValidationProperty : Boolean = BaseValidator.hasProperty(uiComponent, propertyName);
				if (hasValidationProperty) {
			      	result = uiComponent[propertyName];
			      	
					if ((result != null) && (uiComponent is ComboBox)) {
						var hasProperty : Boolean = BaseValidator.hasProperty(result, "data");
						if (hasProperty) {
							result = result.data;
						}
					}
				}
			}
	
			return result;
		}
		
		/**
		 * Helper function that verifies value of the validation control
		 * 
		 * @param name The name of the input control to get the value from.
		 * @return true if control value shouldn't be validated, false if control value must be validated
		 */
		protected function isControlValidationValueNull(name : String) : Boolean {
			var result : Boolean = false;
			var validationValue : Object = getControlValidationValue(name, null);
			
			if (Objects.isSet(validationValue)) {
				if ((validationValue is String) && Strings.isBlank(StringUtil.trim(String(validationValue)))) {
					result = true;
				}
			} else {
				result = true;
			}
			
			return result;
		}
		
		protected function appendEventListeners(control : UIComponent) : void {
			control.addEventListener(FocusEvent.FOCUS_OUT, onControlFocusLost);
			
			var hasNonCommittingChangeEvent : Boolean = ObjectUtil.hasMetadata(control, propertyToValidate, MetadataNames.NON_COMMITTING_CHANGE_EVENT);
			if (hasNonCommittingChangeEvent) {
				var eventName : String = String(ReflectUtil.getMetadata(control, propertyToValidate, MetadataNames.NON_COMMITTING_CHANGE_EVENT).getItemAt(0));
				control.addEventListener(eventName, onControlChange);
			} else {
				control.addEventListener(Event.CHANGE, onControlChange);
			} 
		}
	
		/**
		 * Starts interact with UI
		 */	
		private function evaluateControlErrorString() : void {
			if (isValid) {
				if(controlErrorList.contains(errorMessage)) {
					controlErrorList.removeItemAt(controlErrorList.getItemIndex(errorMessage));
				}
			} else {
				controlErrorList.addItemAt(errorMessage, controlErrorList.length);
			}

			if (controlErrorList.length > 0) {
				controlErrorString = String(controlErrorList.getItemAt(controlErrorList.length - 1));
			} else {
				controlErrorString = "";
			}			
		}
		
		private function clearControlErrorString() : void {
			controlErrorList.removeAll();
			controlErrorString = "";
		}

		private var _controlToValidate : String;
		
		private var _propertyToValidate : String;
		
		private var _enabled : Boolean;
		
		private var _errorMessage : String;
		
		private var _isValid : Boolean;
		
		private var _propertiesChecked : Boolean;
	    
		private var _propertiesValid : Boolean;
		
		private var _isCreationComplete : Boolean;

	}

}