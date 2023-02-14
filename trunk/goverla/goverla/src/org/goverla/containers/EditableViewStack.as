package org.goverla.containers {

	import mx.collections.ArrayCollection;
	import mx.containers.ViewStack;
	import mx.core.Container;
	import mx.states.AddChild;
	import mx.states.SetProperty;
	import mx.states.State;
	
	import org.goverla.controls.editable.common.SaveOrCancelBox;
	import org.goverla.events.EditableControlEvent;
	import org.goverla.events.RemoteValidationResultEvent;
	import org.goverla.events.SaveOrCancelBoxEvent;
	import org.goverla.interfaces.IEditable;
	import org.goverla.interfaces.IEditableGroup;
	import org.goverla.interfaces.IValidatable;

	[Event(name="submitEditedValue", type="org.goverla.events.EditableControlEvent")]
	
	[Event(name="cancelEditedValue", type="org.goverla.events.EditableControlEvent")]
	
	public class EditableViewStack extends ViewStack implements IEditableGroup, IValidatable {
		
		protected static const VIEW_STATE : String = "";
		
		protected static const SHORT_EDIT_STATE : String = "shortEditState";
		
		protected static const FULL_EDIT_STATE : String = "fullEditState";
		
		protected static const VIEW_INDEX : int = 0;

		protected static const EDIT_INDEX : int = 1;
		
		public function EditableViewStack() {
			super();
			
			creationPolicy = "all";
		}
		
		public function get editable() : Boolean {
			return _editable;
		}
		
		public function set editable(editable:Boolean) : void {
			_editable = editable;
			_editableChanged = true;
			invalidateProperties();
		}
		
		public function get editableGroup() : IEditableGroup {
			return _editableGroup;
		}
		
		public function set editableGroup(editableGroup : IEditableGroup) : void {
			if (_editableGroup != null) {
				_editableGroup.removeInstance(this);
			}
			_editableGroup = editableGroup;
			_editableGroup.addInstance(this);
		}
		
		public function get editableChildren() : ArrayCollection {
			return _editableChildren;
		}
		
		public function get reversedEditableChildren() : ArrayCollection {
			return (new ArrayCollection(editableChildren.toArray().reverse()));
		}
		
		public function get saving() : Boolean {
			return (savingCount > 0);
		}
		
		public function get savingCount() : int {
			var result : int = 0;
			for each (var child : IEditable in editableChildren) {
				if (IEditable(child).saving) {
					result++;
				}
			}
			return result;
		}
		
		public function get valid() : Boolean {
			var result : Boolean = true;
			for each (var child : IEditable in editableChildren) {
				if (child is IValidatable) {
					result = result && IValidatable(child).valid;
				}
			}
			if (!result && performingRemoteValidation) {
				enabled = false;
				for each (child in editableChildren) {
					if (child is IValidatable) {
						var validatable : IValidatable = IValidatable(child);
						if (validatable.performingRemoteValidation) {
							validatable.addEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_VALID, onValidationComplete);
							validatable.addEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_INVALID, onValidationComplete);
						}
					}
				}
			}
			return result;
		}
		
		public function get performingRemoteValidation() : Boolean {
			return (performingRemoteValidationCount > 0);
		}
		
		public function get performingRemoteValidationCount() : int {
			var result : int = 0;
			for each (var child : IEditable in editableChildren) {
				if (child is IValidatable) {
					if (IValidatable(child).performingRemoteValidation) {
						result++;
					}
				}
			}
			return result;
		}
		
		protected function get editing() : Boolean {
			return (shortEditState || fullEditState);
		}
		
		protected function get shortEditState() : Boolean {
			return (currentState == SHORT_EDIT_STATE);
		}
		
		protected function get fullEditState() : Boolean {
			return (currentState == FULL_EDIT_STATE);
		}

		protected function get editContainer() : Container {
			return Container(getChildAt(EDIT_INDEX));
		}
		
		override public function initialize() : void {
			super.initialize();
			
			createShortEditState();
			createFullEditState();
		}
		
		public function addInstance(instance : IEditable) : void {
			if (!editableChildren.contains(instance)) {
				editableChildren.addItem(instance);
			}
		}

		public function removeInstance(instance : IEditable) : void {
			if (editableChildren.contains(instance)) {
				if (editing) {
					instance.cancel();
				}
				editableChildren.removeItemAt(editableChildren.getItemIndex(instance));
			}
		}

		public function edit(showSaveAndCancelButtons : Boolean = true) : void {
			for each (var child : IEditable in reversedEditableChildren) {
				child.edit(false);
			}
			currentState = showSaveAndCancelButtons ? FULL_EDIT_STATE : SHORT_EDIT_STATE;
		}
		
		public function view() : void {
			for each (var child : IEditable in editableChildren) {
				child.view();
			}
			currentState = VIEW_STATE;
		}
		
		public function save() : void {
			if (editing) {
				if (valid) {
					_saveOrCancelBox.enabled = false;
					_failedTotal = 0;
					for each (var child : IEditable in editableChildren) {
						child.addEventListener(EditableControlEvent.SAVE, onSaveComplete);
						child.addEventListener(EditableControlEvent.SAVE_FAULT, onSaveComplete);
						child.save();
					}
					dispatchEvent(new EditableControlEvent(EditableControlEvent.SUBMIT_EDITED_VALUE));
				} else if (performingRemoteValidation) {
					addEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_VALID, onBeforeSaveValidationComplete);
					addEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_INVALID, onBeforeSaveValidationComplete);
				}
			}
		}
		
		public function cancel() : void {
			if (editing) {
				for each (var child : IEditable in editableChildren) {
					child.cancel();
				}
				currentState = VIEW_STATE;
				dispatchEvent(new EditableControlEvent(EditableControlEvent.CANCEL_EDITED_VALUE));
			}
		}
		
		override protected function createChildren() : void {
			super.createChildren();
			
			_saveOrCancelBox = new SaveOrCancelBox();
			_saveOrCancelBox.addEventListener(SaveOrCancelBoxEvent.SAVE, onSaveButtonClick);
			_saveOrCancelBox.addEventListener(SaveOrCancelBoxEvent.CANCEL, onCancelButtonClick);
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
			
			if (_editableChanged) {
				if (!_editable) {
					cancel();
				}
				_editableChanged = false;
			}
		}
		
		private function onSaveButtonClick(event : SaveOrCancelBoxEvent) : void {
			save();
		}
		
		private function onCancelButtonClick(event : SaveOrCancelBoxEvent) : void {
			cancel();
		}
		
		private function onSaveComplete(event : EditableControlEvent) : void {
			var saved : IEditable = IEditable(event.currentTarget);
			saved.removeEventListener(EditableControlEvent.SAVE, onSaveComplete);
			saved.removeEventListener(EditableControlEvent.SAVE_FAULT, onSaveComplete);
			if (event.type == EditableControlEvent.SAVE_FAULT) {
				_failedTotal++;
			}
			if (!saving) {
				_saveOrCancelBox.enabled = true;
				if (_failedTotal == 0) {
					view();
					dispatchEvent(new EditableControlEvent(EditableControlEvent.SAVE));
				} else {
					edit(editableGroup == null);
					dispatchEvent(new EditableControlEvent(EditableControlEvent.SAVE_FAULT));
				}
			}
		}

		private function onValidationComplete(event : RemoteValidationResultEvent) : void {
			var validatable : IValidatable = IValidatable(event.currentTarget);
			validatable.removeEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_VALID, onValidationComplete);
			validatable.removeEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_INVALID, onValidationComplete);
			enabled = true;
			if (!performingRemoteValidation) {
				if (valid) {
					dispatchEvent(new RemoteValidationResultEvent(RemoteValidationResultEvent.REMOTE_VALIDATION_VALID));
				} else {
					dispatchEvent(new RemoteValidationResultEvent(RemoteValidationResultEvent.REMOTE_VALIDATION_INVALID));
				}
			}
		}
		
		private function onBeforeSaveValidationComplete(event : RemoteValidationResultEvent) : void {
			removeEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_VALID, onBeforeSaveValidationComplete);
			removeEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_INVALID, onBeforeSaveValidationComplete);
			enabled = true;
			switch (event.type) {
				case RemoteValidationResultEvent.REMOTE_VALIDATION_VALID :
					save();
					break;
				case RemoteValidationResultEvent.REMOTE_VALIDATION_INVALID :
					break;
				default :
			}
		}

		private function createShortEditState() : void {
			var setSelectedIndex : SetProperty = new SetProperty(this, "selectedIndex", EDIT_INDEX);
			
			var overrides : Array = new Array(setSelectedIndex);
			
			var shortEditState : State = new State();
			shortEditState.name = SHORT_EDIT_STATE;
			shortEditState.overrides = overrides;
			
			states.push(shortEditState);
		}

		private function createFullEditState() : void {
			var addSaveOrCancelBox : AddChild = new AddChild(editContainer, _saveOrCancelBox);
			
			var overrides : Array = new Array(addSaveOrCancelBox);

			var fullEditState : State = new State();
			fullEditState.basedOn = SHORT_EDIT_STATE;
			fullEditState.name = FULL_EDIT_STATE;
			fullEditState.overrides = overrides;
			
			states.push(fullEditState);
		}

		private var _saveOrCancelBox : SaveOrCancelBox;
		
		private var _editable : Boolean = true;
		
		private var _editableChanged : Boolean;
		
		private var _editableGroup : IEditableGroup;
		
		private var _editableChildren : ArrayCollection = new ArrayCollection();
		
		private var _failedTotal : int;
		
	}

}