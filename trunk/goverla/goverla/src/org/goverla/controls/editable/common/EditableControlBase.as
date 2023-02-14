package org.goverla.controls.editable.common {

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Box;
	import mx.containers.BoxDirection;
	import mx.containers.FormItem;
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ValidationResultEvent;
	import mx.managers.IFocusManagerComponent;
	import mx.styles.ISimpleStyleClient;
	import mx.validators.Validator;
	
	import org.goverla.collections.AbstractFormDataProvider;
	import org.goverla.constants.StyleNames;
	import org.goverla.events.EditableControlEvent;
	import org.goverla.events.FormDataProviderEvent;
	import org.goverla.events.RemoteValidationResultEvent;
	import org.goverla.interfaces.IBindable;
	import org.goverla.interfaces.IEditable;
	import org.goverla.interfaces.IEditableGroup;
	import org.goverla.interfaces.IRemoteValidator;
	import org.goverla.interfaces.IValidatable;

	[Style(name="viewControlStyleName", type="String", inherit="no")]
	[Style(name="editControlStyleName", type="String", inherit="no")]

	[Event(name="submitEditedValue", type="org.goverla.events.EditableControlEvent")]
	
	[Event(name="cancelEditedValue", type="org.goverla.events.EditableControlEvent")]
	
	public class EditableControlBase extends Box implements IEditable, IValidatable, IBindable, IFocusManagerComponent {
		
		protected static const VIEW_STATE : String = "viewState";
		
		protected static const SHORT_EDIT_STATE : String = "shortEditState";
		
		protected static const FULL_EDIT_STATE : String = "fullEditState";
		
		protected static const CLICK_TO_EDIT : String = "Click to edit";
		
		protected static const HIGHLIGHT_COLOR : uint = 0xFFFFD3;
		
		public var viewBox : Box;
		
		public var editBox : Box;
		
		public var saveOrCancelBox : SaveOrCancelBox;
		
		public function get editable() : Boolean {
			return _editable;
		}
		
		public function set editable(editable : Boolean) : void {
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
		
		public function get formDataProvider() : AbstractFormDataProvider {
			return _formDataProvider;
		}
		
		public function set formDataProvider(formDataProvider : AbstractFormDataProvider) : void {
			if (_formDataProvider != null) {
				_formDataProvider.removeInstance(this);
			}
			_formDataProvider = formDataProvider;
			_formDataProvider.addInstance(this);
		} 

		public function get fieldName() : String {
			return _fieldName;
		}
		
		public function set fieldName(fieldName : String) : void {
			_fieldName = fieldName;
		}
		
		public function get value() : Object {
			return null;
		}

		public function set value(value : Object) : void {
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
		
		[Inspectable(enumeration="horizontal,vertical")]
		public function get saveOrCancelBoxDirection() : String {
			return _saveOrCancelBoxDirection;
		}
		
		public function set saveOrCancelBoxDirection(saveOrCancelBoxDirection : String) : void {
			if (saveOrCancelBoxDirection == BoxDirection.VERTICAL ||
			saveOrCancelBoxDirection == BoxDirection.HORIZONTAL) {
				_saveOrCancelBoxDirection = saveOrCancelBoxDirection;
				_saveOrCancelBoxDirectionChanged = true;
				invalidateProperties();
			}
		}
		
		public function get validator() : Validator {
			return _validator;
		}
		
		public function set validator(validator : Validator) : void {
			_validator = validator;
			
			BindingUtils.bindProperty(_validator, "source", this, "validationSource");
			BindingUtils.bindProperty(_validator, "property", this, "validationProperty");
			
			_validatorChanged = true;
			invalidateProperties();
		}
		
		[Bindable(event="editControlChange")]
		public function get validationSource() : Object {
			return editControl;
		}
		
		public function get validationProperty() : String {
			return "text";
		}
		
		public function get required() : Boolean {
			return _required;
		}
		
		public function set required(required : Boolean) : void {
			_required = required;
			_requiredChanged = true;
			invalidateProperties();
		}
		
		public function get hideEmpty() : Boolean {
			return _hideEmpty;
		}
		
		public function set hideEmpty(hideEmpty : Boolean) : void {
			_hideEmpty = hideEmpty;
			dispatchEvent(new EditableControlEvent(EditableControlEvent.HIDE_EMPTY_CHANGE));
		}
		
		public function get hideEmptyParentFormItem() : Boolean {
			return _hideEmptyParentFormItem;
		}
		
		public function set hideEmptyParentFormItem(hideEmptyParentFormItem : Boolean) : void {
			_hideEmptyParentFormItem = hideEmptyParentFormItem;
			dispatchEvent(new EditableControlEvent(EditableControlEvent.HIDE_EMPTY_PARENT_FORM_ITEM_CHANGE));
		}
		
		[Bindable(event="currentStateChange")]
		public function get editing() : Boolean {
			return (shortEditState || fullEditState);
		}
		
		public function get saving() : Boolean {
			return _saving;
		}
		
		public function get valid() : Boolean {
			var result : Boolean = true;
			if (validator != null) {
				result = (validator.source == null ||
					validator.property == null ||
						validator.validate().type == ValidationResultEvent.VALID);
				if (!result && performingRemoteValidation) {
					enabled = false;
					validator.addEventListener(ValidationResultEvent.VALID, onValidationComplete);
					validator.addEventListener(ValidationResultEvent.INVALID, onValidationComplete);
				}
			}
			return result;
		}
		
		public function get performingRemoteValidation() : Boolean {
			return (validator is IRemoteValidator && IRemoteValidator(validator).performingRemoteValidation);
		}
		
		[Bindable(event="currentStateChange")]
		[Bindable(event="hideEmptyChange")]
		[Bindable(event="viewControlValueCommit")]
		public function get showEmpty() : Boolean {
			return (editing || (viewing && (!empty || !hideEmpty)));
		}
		
		[Bindable(event="currentStateChange")]
		[Bindable(event="hideEmptyParentFormItemChange")]
		[Bindable(event="viewControlValueCommit")]
		public function get showEmptyParentFormItem() : Boolean {
			return (editing || (viewing && (!empty || !hideEmptyParentFormItem)));
		}
		
		public function get filterFunction() : Function {
			return _filterFunction;
		}
		
		public function set filterFunction(filterFunction : Function) : void {
			_filterFunction = filterFunction;
		}
		
		protected final function get viewControl() : UIComponent {
			return _viewControl;
		}

		protected final function set viewControl(viewControl : UIComponent) : void {
			if (_viewControl != null && viewBox.contains(_viewControl)) {
				viewBox.removeChild(_viewControl);
			}

			_viewControl = viewControl;
			_viewControl.addEventListener(MouseEvent.CLICK, onViewControlClick);
			_viewControl.addEventListener(MouseEvent.ROLL_OVER, onViewControlRollOver);
			_viewControl.addEventListener(MouseEvent.ROLL_OUT, onViewControlRollOut);

			_viewControlChanged = true;
			invalidateProperties();
		}

		protected final function get editControl() : UIComponent {
			return _editControl;
		}

		protected final function set editControl(editControl : UIComponent) : void {
			if (_editControl != null && editBox.contains(_editControl)) {
				editBox.removeChild(_editControl);
			}

			_editControl = editControl;
			_editControl.addEventListener(KeyboardEvent.KEY_DOWN, onEditControlKeyDown);
			
			// Trigger binding to editControl-dependent properties
			dispatchEvent(new Event("editControlChange"));
			
			_editControlChanged = true;
			invalidateProperties();
		}
		
		protected final function get viewing() : Boolean {
			return (currentState == VIEW_STATE);
		}
		
		protected final function get shortEditState() : Boolean {
			return (currentState == SHORT_EDIT_STATE);
		}
		
		protected final function get fullEditState() : Boolean {
			return (currentState == FULL_EDIT_STATE);
		}
		
		protected function get empty() : Boolean {
			return false;
		}
		
		override public function initialize() : void {
			super.initialize();
		
			if (parent is FormItem) {
				BindingUtils.bindProperty(parent, "visible", this, "showEmptyParentFormItem");
				BindingUtils.bindProperty(parent, "includeInLayout", this, "showEmptyParentFormItem");
			}
		}

		override public function styleChanged(styleProp : String) : void {
			super.styleChanged(styleProp);
			
			var allStyles : Boolean = (styleProp == null || styleProp == "styleName");
			
			if (allStyles || styleProp == StyleNames.VIEW_CONTROL_STYLE_NAME) {
				if (viewControl != null && viewControl is ISimpleStyleClient) {
					var viewControlStyleName : Object = getStyle(StyleNames.VIEW_CONTROL_STYLE_NAME);
					ISimpleStyleClient(viewControl).styleName = viewControlStyleName;
// TODO Remove following lines (debug purposes only)
/* 					if (allStyles) { 
						trace("viewControl: EVERYTHING CHANGED!");
					} else {
						trace("viewControl: " + viewControlStyleName);
					} */
				}
			}
			
			if (allStyles || styleProp == StyleNames.EDIT_CONTROL_STYLE_NAME) {
				if (editControl != null && editControl is ISimpleStyleClient) {
					var editControlStyleName : Object = getStyle(StyleNames.EDIT_CONTROL_STYLE_NAME);
					ISimpleStyleClient(viewControl).styleName = editControlStyleName;
				}
			}
		}
		
		public function edit(showSaveAndCancelButtons : Boolean = true) : void {
			currentState = showSaveAndCancelButtons ? FULL_EDIT_STATE : SHORT_EDIT_STATE;
		}
		
		public function view() : void {
			currentState = VIEW_STATE;
		}
		
		public function save() : void {
			if (editing) {
				if (valid) {
					submitEditedValue();
					if (formDataProvider != null) {
						_saving = true;
						enabled = false;
						formDataProvider.addEventListener(FormDataProviderEvent.SAVE, onFormDataProviderSaveComplete);
						formDataProvider.addEventListener(FormDataProviderEvent.SAVE_FAULT, onFormDataProviderSaveComplete);
					} else {
						view();
						dispatchEvent(new EditableControlEvent(EditableControlEvent.SAVE));
					}
				} else if (performingRemoteValidation) {
					addEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_VALID, onBeforeSaveValidationComplete);
					addEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_INVALID, onBeforeSaveValidationComplete);
				}
			}
		}
		
		public function cancel() : void {
			if (editing) {
				cancelEditedValue();
				view();
			}
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
			
			if (_editableChanged) {
				viewControl.toolTip = (_editable ? CLICK_TO_EDIT : null);
				if (!_editable) {
					cancel();
				}
				_editableChanged = false;
			}
			
			if (_viewControlChanged) {
				var viewControlStyleName : String = getStyle(StyleNames.VIEW_CONTROL_STYLE_NAME);
				if (viewControlStyleName != null && _viewControl is ISimpleStyleClient) {
					ISimpleStyleClient(_viewControl).styleName = viewControlStyleName;
				}
				viewBox.addChild(_viewControl);
				_viewControlChanged = false;
			}
			
			if (_editControlChanged) {
				var editControlStyleName : String = getStyle(StyleNames.EDIT_CONTROL_STYLE_NAME);
				if (editControlStyleName != null && _editControl is ISimpleStyleClient) {
					ISimpleStyleClient(_editControl).styleName = editControlStyleName;
				}
				editBox.addChildAt(_editControl, 0);
				_editControlChanged = false;
			}
			
			if (_saveOrCancelBoxStateChanged) {
				saveOrCancelBox.currentState = _saveOrCancelBoxState;
				_saveOrCancelBoxStateChanged = false;
			}
			
			if (_saveOrCancelBoxDirectionChanged) {
				saveOrCancelBox.direction = _saveOrCancelBoxDirection;
				_saveOrCancelBoxDirectionChanged = false;
			}
			
			if (_validatorChanged || _requiredChanged) {
				if (validator != null) {
					validator.required = _required;
				}
				_validatorChanged = false;
				_requiredChanged = false
			}
		}

		protected final function onSaveButtonClick() : void {
			save();
		}
		
		protected final function onCancelButtonClick() : void {
			cancel();
		}
		
		protected final function onViewStateEnter() : void {
			viewControl.addEventListener(FlexEvent.UPDATE_COMPLETE, onViewControlUpdateComplete);
		}
		
		protected final function onEditStateEnter() : void {
			editControl.addEventListener(FlexEvent.UPDATE_COMPLETE, onEditControlUpdateComplete);
		}
		
		protected function submitEditedValue() : void {
			dispatchEvent(new EditableControlEvent(EditableControlEvent.SUBMIT_EDITED_VALUE));
		}
		
		protected function cancelEditedValue() : void {
			dispatchEvent(new EditableControlEvent(EditableControlEvent.CANCEL_EDITED_VALUE));
		}
		
		protected function onViewState() : void {
		}
		
		protected function onEditState() : void {
			if (validator != null) {
				validator.validate();
			}
		}
		
		private function onViewControlUpdateComplete(event : FlexEvent) : void {
			viewControl.removeEventListener(FlexEvent.UPDATE_COMPLETE, onViewControlUpdateComplete);
			onViewState();
		}
		
		private function onEditControlUpdateComplete(event : FlexEvent) : void {
			editControl.removeEventListener(FlexEvent.UPDATE_COMPLETE, onEditControlUpdateComplete);
			onEditState();
		}
		
		private function onViewControlClick(event : MouseEvent) : void {
			if (editable) {
				edit();
			}
		}
		
		private function onViewControlRollOver(event : MouseEvent) : void {
			if (editable) {
				viewBox.setStyle("backgroundColor", HIGHLIGHT_COLOR);
			}
		}
		
		private function onViewControlRollOut(event : MouseEvent) : void {
			if (editable) {
				viewBox.clearStyle("backgroundColor");
			}
		}
		
		private function onEditControlKeyDown(event : KeyboardEvent) : void {
			if (fullEditState) {
				switch (event.keyCode) {
					case Keyboard.ENTER :
						if (event.currentTarget is TextArea) {
							if (event.ctrlKey) {
								onSaveButtonClick();
							}
						} else {
							onSaveButtonClick();
						}
						break;
					case Keyboard.ESCAPE : 
						onCancelButtonClick();
						break;
					default : 
				}
			}
		}
		
		private function onFormDataProviderSaveComplete(event : FormDataProviderEvent) : void {
			formDataProvider.removeEventListener(FormDataProviderEvent.SAVE, onFormDataProviderSaveComplete);
			formDataProvider.removeEventListener(FormDataProviderEvent.SAVE_FAULT, onFormDataProviderSaveComplete);
			_saving = false;
			enabled = true;
			switch (event.type) {
				case FormDataProviderEvent.SAVE :
					view();
					dispatchEvent(new EditableControlEvent(EditableControlEvent.SAVE));
					break;
				case FormDataProviderEvent.SAVE_FAULT :
					edit(editableGroup == null);
					dispatchEvent(new EditableControlEvent(EditableControlEvent.SAVE_FAULT));
					break;
				default :
			}
		}
		
		private function onValidationComplete(event : ValidationResultEvent) : void {
			validator.removeEventListener(ValidationResultEvent.VALID, onValidationComplete);
			validator.removeEventListener(ValidationResultEvent.INVALID, onValidationComplete);
			enabled = true;
			switch (event.type) {
				case ValidationResultEvent.VALID :
					dispatchEvent(new RemoteValidationResultEvent(RemoteValidationResultEvent.REMOTE_VALIDATION_VALID));
					break;
				case ValidationResultEvent.INVALID :
					dispatchEvent(new RemoteValidationResultEvent(RemoteValidationResultEvent.REMOTE_VALIDATION_INVALID));
					break;
				default :
			}
		}
		
		private function onBeforeSaveValidationComplete(event : RemoteValidationResultEvent) : void {
			removeEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_VALID, onBeforeSaveValidationComplete);
			removeEventListener(RemoteValidationResultEvent.REMOTE_VALIDATION_INVALID, onBeforeSaveValidationComplete);
			switch (event.type) {
				case RemoteValidationResultEvent.REMOTE_VALIDATION_VALID :
					save();
					break;
				case RemoteValidationResultEvent.REMOTE_VALIDATION_INVALID :
					break;
				default :
			}
		}
		
		private var _editable : Boolean = true;
		
		private var _editableChanged : Boolean;
		
		private var _editableGroup : IEditableGroup;
		
		private var _viewControl : UIComponent;
		
		private var _viewControlChanged : Boolean;

		private var _editControl : UIComponent;
		
		private var _editControlChanged : Boolean;
		
		private var _validator : Validator;
		
		private var _validatorChanged : Boolean;
		
		private var _required : Boolean;
		
		private var _requiredChanged : Boolean;

		private var _saveOrCancelBoxState : String;
		
		private var _saveOrCancelBoxStateChanged : Boolean;

		private var _saveOrCancelBoxDirection : String;
		
		private var _saveOrCancelBoxDirectionChanged : Boolean;
		
		private var _hideEmpty : Boolean;
		
		private var _hideEmptyParentFormItem : Boolean = true;
		
		private var _formDataProvider : AbstractFormDataProvider;
		
		private var _fieldName : String;
		
		private var _saving : Boolean;
		
		private var _filterFunction : Function; 
		
	}

}