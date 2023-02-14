package org.goverla.controls.editable.common {

	import mx.containers.BoxDirection;
	import mx.controls.Label;
	import mx.events.FlexEvent;
	
	import org.goverla.events.EditableControlEvent;
	import org.goverla.utils.Strings;
	
	public class EditableLabel extends EditableControl {

		public function EditableLabel() {
			super();
			
			direction = BoxDirection.HORIZONTAL;

			viewControl = new Label();

			viewLabel.percentWidth = 100;
			viewLabel.minWidth = 0;
			viewLabel.addEventListener(FlexEvent.VALUE_COMMIT, onViewLabelValueCommit);
		}
		
		public function get selectable() : Boolean {
			return _selectable;
		}
		
		public function set selectable(selectable : Boolean) : void {
			_selectable = selectable;
			_selectableChanged = true;
			invalidateProperties();
		}
		
		protected final function get viewLabel() : Label {
			return Label(viewControl);
		}
		
		override protected function get empty() : Boolean {
			return Strings.isBlank(viewLabel.text);
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
			
			if (_selectableChanged) {
				viewLabel.selectable = _selectable;
				_selectableChanged = false;
			}
		}
		
		protected function onViewLabelValueCommit(event : FlexEvent) : void {
			dispatchEvent(new EditableControlEvent(EditableControlEvent.VIEW_CONTROL_VALUE_COMMIT));
		}
		
		private var _selectable : Boolean;
		
		private var _selectableChanged : Boolean;
		
	}

}