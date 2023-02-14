package org.goverla.controls.editable {

	import flash.events.Event;
	import flash.events.TextEvent;
	
	import mx.events.FlexEvent;
	
	import org.goverla.controls.ExtendedLabel;
	import org.goverla.controls.ExtendedText;
	import org.goverla.controls.ExtendedTextArea;
	import org.goverla.controls.ExtendedTextInput;
	import org.goverla.controls.MaskedTextInput;
	import org.goverla.controls.editable.common.EditableControl;
	import org.goverla.events.EditableControlEvent;
	import org.goverla.interfaces.ITextEdit;
	import org.goverla.interfaces.ITextView;
	import org.goverla.utils.EventRedispatcher;
	import org.goverla.utils.Objects;
	import org.goverla.utils.Strings;
	
	[Event(name="change", type="flash.events.Event")]
	
	[Event(name="enter", type="mx.events.FlexEvent")]
	
	[Event(name="textInput", type="flash.events.TextEvent")]
	
	public class EditableText extends EditableControl {
		
		protected static const LABEL : String = "Label";
		
		protected static const TEXT : String = "Text";
		
		protected static const TEXT_INPUT : String = "TextInput";
		
		protected static const MASKED_TEXT_INPUT : String = "MaskedTextInput";
		
		protected static const TEXT_AREA : String = "TextArea";
		
		public function get viewTextControl() : ITextView {
			return ITextView(viewControl);
		}
		
		public function get editTextControl() : ITextEdit {
			return ITextEdit(editControl);
		}
		
		override public function get value() : Object {
			return text;
		}
		
		override public function set value(value : Object) : void {
			if (filterFunction != null) {
				text = Objects.castToString(filterFunction(Objects.castToString(value)));
			} else {
				text = Objects.castToString(value);
			}
		}
		
		public function get text() : String {
			return _text;
		}
		
		public function set text(value : String) : void {
			_text = value;
			_textChanged = true;
			invalidateProperties();
		}
		
		public function get viewFilterFunction() : Function {
			return _viewFilterFunction;
		}
		
		public function set viewFilterFunction(viewFilterFunction : Function) : void {
			_viewFilterFunction = viewFilterFunction;
		}

		public function get htmlEnabled() : Boolean {
			return _htmlEnabled;
		} 

		public function set htmlEnabled(value : Boolean) : void {
			_htmlEnabled = value;
		} 	
		
		override public function set editable(value : Boolean) : void {
			super.editable = value;
		}
		
		[Inspectable(enumeration="Label,Text")]
		public function get viewMode() : String {
			return _viewMode;
		}
		
		public function set viewMode(value : String) : void {
			_viewMode = value;
			_viewModeChanged = true;
			invalidateProperties();
		}
		
		[Inspectable(enumeration="TextInput,MaskedTextInput,TextArea")]
		public function get editMode() : String {
			return _editMode;
		}
		
		public function set editMode(value : String) : void {
			_editMode = value;
			_editModeChanged = true;
			invalidateProperties();
		}
		
		public function get maxChars() : int  {
			return _maxChars;
		}
		
		public function set maxChars(value : int) : void {
			_maxChars = value;
			_maxCharsChanged = true;
			invalidateProperties();
		}
		
		public function get restrict() : String {
			return _restrict;
		}
		
		public function set restrict(value : String) : void {
			_restrict = value;
			_restrictChanged = true;
			invalidateProperties();
		}
		
		public function get selectable() : Boolean {
			return _selectable;
		}
		
		public function set selectable(value : Boolean) : void {
			_selectable = value;
			_selectableChanged = true;
			invalidateProperties();
		}
		
		public function get defaultText() : String {
			return _defaultText;
		}
		
		public function set defaultText(value : String) : void {
			_defaultText = value;
			_defaultTextChanged = true;
			invalidateProperties();
		}
		
		public function get showDefaultTextEverywhere() : Boolean {
			return _showDefaultTextEverywhere;
		}
		
		public function set showDefaultTextEverywhere(value : Boolean) : void {
			_showDefaultTextEverywhere = value;
			_showDefaultTextEverywhereChanged = true;
			invalidateProperties();
		}
		
		public function get inputMask() : String {
			return _inputMask;
		}
		
		public function set inputMask(inputMask : String) : void {
			_inputMask = inputMask;
			_inputMaskChanged = true;
			invalidateProperties();
		}
		
		public function get blankChar() : String {
			return _blankChar;
		}
		
		public function set blankChar(blankChar : String) : void {
			_blankChar = blankChar;
			_blankCharChanged = true;
			invalidateProperties();
		}
		
		public function get maskedText() : String {
			if (editMode == MASKED_TEXT_INPUT) {
				return MaskedTextInput(editControl).maskedText;
			} else {
				return text;
			}
		}
		
		override protected function get empty() : Boolean {
			return (editMode == MASKED_TEXT_INPUT && _inputMask != null ?
				Strings.isBlank(_text) :
				(viewTextControl == null || viewTextControl.empty));
		}
		
		override public function cancel() : void {
			_textChanged = true;
			invalidateProperties();
			super.cancel();
		}
		
// TODO Remove following lines (debug purposes only)
/* 		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			if (viewMode == TEXT && editMode == TEXT_INPUT) {
				trace("viewControl: " + viewControl.styleName);
			}
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
 */		
		override protected function commitProperties() : void {
			if (_viewModeChanged) {
				if (_viewMode == LABEL) {
					viewControl = new ExtendedLabel();
					viewControl.percentWidth = 100;
					viewControl.minWidth = 0;
				} else if (_viewMode == TEXT) {
					viewControl = new ExtendedText();
					//viewControl.regenerateStyleCache(false);
					viewControl.percentWidth = 100;
				}
				viewControl.addEventListener(FlexEvent.VALUE_COMMIT, onViewControlValueCommit);
				new EventRedispatcher(this).facadeEvents(viewControl, TextEvent.LINK);
				_textChanged = true;
				_selectableChanged = true;
				_defaultTextChanged = true;
				_viewModeChanged = false;
			}
			
			if (_editModeChanged) {
				if (_editMode == TEXT_INPUT) {
					editControl = new ExtendedTextInput();
					editControl.percentWidth = 100;
				} else if (_editMode == MASKED_TEXT_INPUT) {
					editControl = new MaskedTextInput();
					editControl.percentWidth = 100;
				} else if (_editMode == TEXT_AREA) {
					editControl = new ExtendedTextArea();
					editControl.percentWidth = 100;
					editControl.percentHeight = 100;
				}
				new EventRedispatcher(this).facadeEvents(editControl, Event.CHANGE, FlexEvent.ENTER, TextEvent.TEXT_INPUT);
				_textChanged = true;
				_maxCharsChanged = true;
				_restrictChanged = true;
				_defaultTextChanged = true;
				_editModeChanged = false;
			}
			
			if (_inputMaskChanged) {
				if (_editMode == MASKED_TEXT_INPUT) {
					MaskedTextInput(editControl).inputMask = _inputMask;
				}
				_inputMaskChanged = false;
			}
			
			if (_blankCharChanged) {
				if (_editMode == MASKED_TEXT_INPUT) {
					MaskedTextInput(editControl).blankChar = _blankChar;
				}
				_blankCharChanged = false;
			}
			
			if (_selectableChanged) {
				viewTextControl.selectable = _selectable;
				_selectableChanged = false;
			}
			
			if (_maxCharsChanged) {
				editTextControl.maxChars = _maxChars;
				_maxCharsChanged = false;
			}
			
			if (_restrictChanged) {
				editTextControl.restrict = _restrict;
				_restrictChanged = false;
			}
			
			if (_defaultTextChanged) {
				editTextControl.defaultText = _defaultText;
				showEmptyText();
				_defaultTextChanged = false;
			}
			
			if (_showDefaultTextEverywhereChanged) {
				showEmptyText();
				_showDefaultTextEverywhereChanged = false;
			}
			
			if (_textChanged) {
				if (Strings.isBlank(_text) && (formDataProvider == null || _textChanged)) {
					showEmptyText();
					if (_htmlEnabled) {
						editTextControl.htmlText = "";
					} else {
						editTextControl.text = "";
					}
				} else if (_textChanged) {
					if (_htmlEnabled) {
						viewTextControl.htmlText = (viewFilterFunction != null ?
							Objects.castToString(viewFilterFunction(Objects.castToString(_text))) :
							_text);
					} else {
						viewTextControl.text = (viewFilterFunction != null ?
							Objects.castToString(viewFilterFunction(Objects.castToString(_text))) :
							_text);
					}
					editTextControl.text = _text;
				}
				_textChanged = false;
			}
			
			super.commitProperties();
		}
		
		override protected function submitEditedValue() : void {
			value = editTextControl.text;
			super.submitEditedValue();
		}
		
		override protected function cancelEditedValue() : void {
			value = _text;
			super.cancelEditedValue();
		}
		
		override protected function onEditState() : void {
			editControl.setFocus();
			editTextControl.setSelection(0, editTextControl.length);
		}
		
		protected function onViewControlValueCommit(event : FlexEvent) : void {
			dispatchEvent(new EditableControlEvent(EditableControlEvent.VIEW_CONTROL_VALUE_COMMIT));
		}
		
		private function showEmptyText() : void {
			if (Strings.isBlank(_text)) {
				if (_showDefaultTextEverywhere) {
					viewTextControl.text = _defaultText;
				} else {
					viewTextControl.text = "";
				}
			}
		}
		
		private var _viewMode : String = TEXT;
		
		private var _viewModeChanged : Boolean = true;
		
		private var _editMode : String = TEXT_AREA;
		
		private var _editModeChanged : Boolean = true;
		
		private var _text : String = "";
		
		private var _textChanged : Boolean;
		
		private var _htmlEnabled : Boolean;
		
		private var _defaultText : String = "";
		
		private var _defaultTextChanged : Boolean;
		
		private var _showDefaultTextEverywhere : Boolean;
		
		private var _showDefaultTextEverywhereChanged : Boolean;
		
		private var _maxChars : int;
		
		private var _maxCharsChanged : Boolean;
		
		private var _restrict : String;
		
		private var _restrictChanged : Boolean;
		
		private var _selectable : Boolean;
		
		private var _selectableChanged : Boolean;
		
		private var _inputMask : String;
		
		private var _inputMaskChanged : Boolean;
		
		private var _blankChar : String = "_";
		
		private var _blankCharChanged : Boolean;
		
		private var _viewFilterFunction : Function; 
		
	}
	
}