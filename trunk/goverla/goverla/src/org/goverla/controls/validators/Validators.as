package org.goverla.controls.validators {
	
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.core.Container;
	
	import org.goverla.events.ValidatorEvent;
	import org.goverla.interfaces.IValidator;
	import org.goverla.utils.Arrays;
	import org.goverla.utils.comparing.PropertyCompareRequirement;
	
	/**
	 * @author Tyutyunnyk Eugene
	 */
	[Event(name="isValidChange")]
	public class Validators extends Container implements IValidator {
		
		[ChangeEvent("enabledChange")]
		public override function get enabled() : Boolean {
			return _enabled;
		}
		
		public override function set enabled(enabled : Boolean) : void {
			for each(var validator : Object in _validators) {
				IValidator(validator).enabled = enabled;
			}
			
			_enabled = enabled;
			
			dispatchEvent(new ValidatorEvent(ValidatorEvent.ENABLED_CHANGE));
		}
		
		public function set errorMessage(text : String) : void {
			_errorMessage = text;
		}
	
		public function get errorMessage() : String {
			return _errorMessage;
		}
		
		[Bindable(event="isValidChange")]
		public function get isValid() : Boolean {
			evaluateIsValid();
			return _isValid;
		}
		
		public function Validators() {
			super();
			_validators = new ArrayCollection();
		}
		
		public function addValidator(validator : IValidator) : void {
			if (!_validators.contains(validator)) {
				_validators.addItem(validator);
			}
		}
		
		public function removeValidator(validatorId : String) : void {
			var requirement : PropertyCompareRequirement = new PropertyCompareRequirement("id", validatorId);
			if (Arrays.containsByRequirement(_validators, requirement)) {	
				var resultList : ArrayCollection = Arrays.getByRequirement(_validators, requirement);	
				_validators.removeItemAt(_validators.getItemIndex(resultList[0]));
			}
		}
	
		public function validate() : void {
			_isValid = true;
			
			var cursor : IViewCursor = _validators.createCursor();
			while (cursor.moveNext()) {
				IValidator(cursor.current).validate();
				_isValid = _isValid && IValidator(cursor.current).isValid; 
			}
		}
		
		protected function evaluateIsValid() : void {
			_isValid = true;
			
			for each(var validator : IValidator in _validators) {
				_isValid = _isValid && validator.isValid;
			}
			
		}
		
		protected override function createChildren() : void {
			super.createChildren();
			
			for (var i : Number = 0; i < numChildren; i++) {
				var child : DisplayObject = getChildAt(i); 
				if(!child is IValidator) {
					throw new TypeError(child +" must implements IValidator interface");
				} 
				_validators.addItem(child);
				var validator : IValidator = IValidator(child);
				validator.addEventListener(ValidatorEvent.IS_VALID_CHANGE, onChildIsValidChange);
			}
			dispatchEvent(new ValidatorEvent(ValidatorEvent.IS_VALID_CHANGE));
		}
		
		private function onChildIsValidChange(event : ValidatorEvent) : void {
			var previousIsValid : Boolean = _isValid;
			evaluateIsValid();
			if(previousIsValid != _isValid) {
				dispatchEvent(new ValidatorEvent(ValidatorEvent.IS_VALID_CHANGE));
			}
		}
		
		private var _errorMessage : String;
		
		private var _isValid : Boolean;
		
		private var _validators : ArrayCollection;
		
		private var _enabled : Boolean;

	}
}