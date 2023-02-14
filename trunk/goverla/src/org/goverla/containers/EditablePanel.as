package org.goverla.containers {

	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	import mx.core.mx_internal;
	import mx.states.AddChild;
	import mx.states.SetProperty;
	import mx.states.State;
	
	import org.goverla.constants.Icons;
	import org.goverla.constants.StyleNames;
	import org.goverla.controls.ExtendedLinkButton;
	import org.goverla.controls.editable.common.SaveOrCancelBox;
	import org.goverla.events.EditableControlEvent;
	import org.goverla.events.RemoteValidationResultEvent;
	import org.goverla.events.SaveOrCancelBoxEvent;
	import org.goverla.interfaces.IEditable;
	import org.goverla.interfaces.IEditableGroup;
	import org.goverla.interfaces.IValidatable;
	
	use namespace mx_internal;

	[Event(name="submitEditedValue", type="org.goverla.events.EditableControlEvent")]
	
	[Event(name="cancelEditedValue", type="org.goverla.events.EditableControlEvent")]
	
	public class EditablePanel extends CollapsablePanel implements IEditableGroup, IValidatable {
		
		protected static const EDIT_STATE : String = "editState";
		
		protected static const EDIT_ICON : Class = Icons.ICON_16X16_EDIT_UP;
		
		protected static const CLICK_TO_EDIT : String = "Click to edit";
		
		protected static const EDIT_LINK_BUTTON_LABEL : String = "Edit";
		
		protected static const ENABLED_LINK_BUTTON_ALPHA : Number = 1;
		
		protected static const DISABLED_LINK_BUTTON_ALPHA : Number = 0.1;
		
		public function EditablePanel() {
			super();
		}
		
		public function get editable() : Boolean {
			return _editable;
		}
		
		public function set editable(editable : Boolean) : void {
			_editable = editable;
			_editableChanged = true;
			invalidateProperties();
		}
		
		public function get editing() : Boolean {
			return _editing;
		}
		
		public function set editing(editing : Boolean) : void {
			_editing = editing;
			_editingChanged = true;
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
		
		public function get showEditLinkButton() : Boolean {
			return _showEditLinkButton;
		}
		
		public function set showEditLinkButton(showEditLinkButton : Boolean) : void {
			_showEditLinkButton = showEditLinkButton;
			_showEditLinkButtonChanged = true;
			invalidateProperties();
		}
		
		[Inspectable(enumeration="buttonState,buttonWithIconState,linkButtonState,linkButtonWithIconState,iconState")]
		public function get saveOrCancelBoxState() : String {
			return _saveOrCancelBoxState;
		}
		
		public function set saveOrCancelBoxState(saveOrCancelBoxState : String) : void {
			if (saveOrCancelBoxState == SaveOrCancelBox.BUTTON_STATE ||
			saveOrCancelBoxState == SaveOrCancelBox.BUTTON_WITH_ICON_STATE ||
			saveOrCancelBoxState == SaveOrCancelBox.LINK_BUTTON_STATE ||
			saveOrCancelBoxState == SaveOrCancelBox.LINK_BUTTON_WITH_ICON_STATE ||
			saveOrCancelBoxState == SaveOrCancelBox.ICON_STATE) {
				_saveOrCancelBoxState = saveOrCancelBoxState;
				_saveOrCancelBoxStateChanged = true;
				invalidateProperties();
			}
		}
		
		public function get maximizeOnEdit() : Boolean {
			return _maximizeOnEdit;
		}
		
		public function set maximizeOnEdit(maximizeOnEdit : Boolean) : void {
			_maximizeOnEdit = maximizeOnEdit;
			_maximizeOnEditChanged = true;
			invalidateProperties();
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
		
		override protected function get oppositeState() : String {
			var result : String = COLLAPSED_STATE;
			if (collapsed) {
				result = (editing ? EDIT_STATE : RESTORED_STATE);
			}
			return result;
		}
		
		protected function get controlContainer() : Container {
			return (controlBar != null ? Container(controlBar) : Container(this));
		}
		
		override public function restore() : void {
			if (editing) {
				changeCurrentState(EDIT_STATE, false);
			} else {
				changeCurrentState(RESTORED_STATE, false);
			}
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
			editing = true;
			scrollToTopLeft();
		}

		public function view() : void {
			for each (var child : IEditable in editableChildren) {
				child.view();
			}
			editing = false;
			scrollToTopLeft();
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
				editing = false;
				scrollToTopLeft();
				dispatchEvent(new EditableControlEvent(EditableControlEvent.CANCEL_EDITED_VALUE));
			}
		}
		
		override protected function createChildren() : void {
			super.createChildren();
			
			_saveOrCancelBox = new SaveOrCancelBox();
			_saveOrCancelBox.addEventListener(SaveOrCancelBoxEvent.SAVE, onSaveButtonClick);
			_saveOrCancelBox.addEventListener(SaveOrCancelBoxEvent.CANCEL, onCancelButtonClick);

			_editLinkButton = new ExtendedLinkButton();
			_editLinkButton.label = EDIT_LINK_BUTTON_LABEL;
			_editLinkButton.tabEnabled = false;
			_editLinkButton.setStyle(StyleNames.ICON, EDIT_ICON);
			_editLinkButton.setStyle(StyleNames.HORIZONTAL_GAP, 0);
			_editLinkButton.addEventListener(MouseEvent.CLICK, onEditLinkButtonClick);
			
			rawChildren.addChild(_editLinkButton);

			createEditState();
			
			if (controlBar != null) {
				setStyle(StyleNames.BORDER_THICKNESS_BOTTOM, getStyle(StyleNames.BORDER_THICKNESS_LEFT));
			}
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
			
			if (_editableChanged || _showEditLinkButtonChanged) {
				_editLinkButton.visible = (_editable && _showEditLinkButton);

				if (_editableChanged) {
					if (!_editable) {
						cancel();
					}
					_editableChanged = false;
				}
				
				if (_showEditLinkButtonChanged) {
					_showEditLinkButtonChanged = false;
				}
			}
			
			if (_editingChanged) {
				_editLinkButton.enabled = !_editing;
				_editLinkButton.buttonMode = !_editing;
				_editLinkButton.toolTip = (_editing ? CLICK_TO_EDIT : null);
				
				if (controlBar != null) {
					controlBar.visible = _editing;
					controlBar.includeInLayout = _editing;
				}

				if (_editing) {
					changeCurrentState(EDIT_STATE);
				} else if (currentState == EDIT_STATE) {
					changeCurrentState(RESTORED_STATE);
				}

				_editingChanged = false;
			}
			
			if (_saveOrCancelBoxStateChanged) {
				_saveOrCancelBox.currentState = _saveOrCancelBoxState;
				_saveOrCancelBoxStateChanged = false;
			}
			
			if (_maximizeOnEditChanged) {
				if (_maximizeOnEdit) {
					_editState.overrides = _editStateOverridesWithMaximize;
				} else {
					_editState.overrides = _editStateOverrides;
				}
				_maximizeOnEditChanged = false;
			}
		}
		
		override protected function updateDisplayList(w : Number, h : Number) : void {
			super.updateDisplayList(w, h);
			
 			var editLinkButtonWidth : Number = _editLinkButton.getExplicitOrMeasuredWidth();
			var editLinkButtonHeight : Number = _editLinkButton.getExplicitOrMeasuredHeight();
			_editLinkButton.setActualSize(editLinkButtonWidth, editLinkButtonHeight);

			_editLinkButton.x = w - _editLinkButton.width - getStyle(StyleNames.BORDER_THICKNESS_RIGHT);
			_editLinkButton.y = (getTitleBarHeight() - _editLinkButton.height) / 2;
		}
		
		private function onEditLinkButtonClick(event : MouseEvent) : void {
			if (!editing) {
				edit();
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
				editing = false;
				scrollToTopLeft();
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

		private function scrollToTopLeft() : void {
			verticalScrollPosition = 0;
			horizontalScrollPosition = 0;
		}
		
		private function createEditState() : void {
			var addSaveOrCancelBox : AddChild = new AddChild(controlContainer, _saveOrCancelBox);
			var setHeight : SetProperty = new SetProperty(this, "percentHeight", 100);
			
			_editStateOverrides = new Array(addSaveOrCancelBox);
			_editStateOverridesWithMaximize = _editStateOverrides.concat(setHeight);

			_editState = new State();
			_editState.name = EDIT_STATE;
			_editState.overrides = _editStateOverrides;
			
			states.push(_editState);
		}
		
		private var _editable : Boolean = true;
		
		private var _editableChanged : Boolean;
		
		private var _editableGroup : IEditableGroup;
		
		private var _showEditLinkButton : Boolean = true;
		
		private var _showEditLinkButtonChanged : Boolean;
		
		private var _editing : Boolean;
		
		private var _editingChanged : Boolean = true;
		
		private var _saveOrCancelBox : SaveOrCancelBox;
		
		private var _saveOrCancelBoxState : String;
		
		private var _saveOrCancelBoxStateChanged : Boolean;
		
		private var _maximizeOnEdit : Boolean;
		
		private var _maximizeOnEditChanged : Boolean;

		private var _editLinkButton : ExtendedLinkButton;
		
		private var _editState : State;
		
		private var _editStateOverrides : Array;
		
		private var _editStateOverridesWithMaximize : Array;
		
		private var _editableChildren : ArrayCollection = new ArrayCollection();
		
		private var _failedTotal : int;
		
	}

}