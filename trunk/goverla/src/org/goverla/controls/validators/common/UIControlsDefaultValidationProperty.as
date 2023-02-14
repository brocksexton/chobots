package org.goverla.controls.validators.common {
	
	import mx.core.UIComponent;
	
	import org.goverla.collections.HashMap;
	
	/**
	 * @author Tyutyunnyk Eugene
	 */
	public class UIControlsDefaultValidationProperty {
		
		public static var pairs : HashMap = UIControlsDefaultValidationProperty.getPairs();
		
		public static function getPropertyByControlInstance(control : UIComponent) : String {
			if (control != null) {
				return getPropertyByControlType(control.className);
			} else {
				return null;
			}
		}
		
		public static function getPropertyByControlType(className : String) : String {
			return String(UIControlsDefaultValidationProperty.pairs.getItem(className));
		}
		
		private static function getPairs() : HashMap {
			var result : HashMap = new HashMap();
			
			result.addItem("TextInput", "text");
			result.addItem("TextArea", "text");
			result.addItem("ComboBox", "selectedItem");
			result.addItem("NumericStepper", "value");
			
			return result;
		}
		
	}
}