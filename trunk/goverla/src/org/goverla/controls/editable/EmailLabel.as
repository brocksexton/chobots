package org.goverla.controls.editable {

	import org.goverla.controls.editable.validators.StrictEmailValidator;
	
	public class EmailLabel extends TextInputLabel {
		
		public function EmailLabel() {
			super();
			
			validator = new StrictEmailValidator();
		}
		
	}

}