package org.goverla.controls.editable {
	
	import mx.containers.BoxDirection;
	
	public class TextInputLabel extends EditableText {

		public function TextInputLabel() {
			super();
			editMode = "MaskedTextInput";
			viewMode = "Label";
			direction = BoxDirection.HORIZONTAL;
		}
		
	}

}