package org.goverla.controls.editable {

	import mx.validators.ZipCodeValidator;

	public class ZipCodeLabel extends TextInputLabel {
		
		public function ZipCodeLabel() {
			super();
			
			validator = new ZipCodeValidator();
		}
		
	}

}