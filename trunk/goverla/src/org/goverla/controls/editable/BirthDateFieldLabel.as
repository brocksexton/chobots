package org.goverla.controls.editable {

	import org.goverla.controls.editable.validators.BirthDateValidator;

	public class BirthDateFieldLabel extends DateFieldLabel {
		
		[Bindable(event="editControlChange")]
		override public function get validationSource() : Object {
			return editDateField;
		}

		public function BirthDateFieldLabel() {
			super();

			selectableRange = {rangeEnd : new Date()};
			validator = new BirthDateValidator();
		}
		
	}

}