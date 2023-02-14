package org.goverla.controls.validators.examples {

	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	import org.goverla.constants.CreditCardNames;
	import org.goverla.controls.validators.CustomValidator;
	import org.goverla.controls.validators.Validators;
	
	/**
	 * @author Tyutyunnyk Eugene
	 */
	public class ValidatorsViewBase extends VBox {
		
		public var validators1 : Validators;
		
		public var validators2 : Validators;
		
		public var customVal : CustomValidator;
		
		public var validate1Button : Button;
		
		public var validate2Button : Button;
		
		[ChangeEvent("providerChanged")] 
		public var comboBox1DataProvider : Array = [{data : null, label : ""}, {data : 0, label : "item 0"}, {data : 1, label : "item 1"}, {data : 2, label : "item 2"}];
		
		[ChangeEvent("providerChanged")]
		public var comboBox2DataProvider : Array = [24, 55, 88, 47];
		
		[ChangeEvent("providerChanged")]
		public var comboBox3DataProvider : Array = [88, 11, 97, 63];
		
		[ChangeEvent("providerChanged")]
		public var comboBox4DataProvider : Array = [CreditCardNames.AMERICAN_EXPRESS, 
				CreditCardNames.MASTER_CARD, 
				CreditCardNames.DISCOVER, 
				CreditCardNames.VISA];
		
		public function ValidatorsViewBase() {
			super();
	
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
	
		private function onCreationComplete(event : Event) : void {
			validate1Button.addEventListener(MouseEvent.CLICK, onValidate1ButtonClick);
			validate2Button.addEventListener(MouseEvent.CLICK, onValidate2ButtonClick);
			
			customVal.onValidate = onCustomValValidate;
		}
		
		private function onValidate1ButtonClick(event : Event) : void {
			validators1.validate();	
		}
		
		private function onValidate2ButtonClick(event : Event) : void {
			validators2.validate();	
		}
		
		private function onCustomValValidate(value : Object) : Boolean {
			if (String(value) == "11") {
				return true;
			}
			
			return false;
		}
	}
}