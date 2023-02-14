package org.goverla.controls.editable {

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	
	import org.goverla.controls.editable.common.EditableControl;
	import org.goverla.controls.editable.validators.TagsValidator;
	import org.goverla.events.EditableControlEvent;
	import org.goverla.utils.EventRedispatcher;
	import org.goverla.utils.Objects;
	import org.goverla.utils.Strings;
	
	[Event(name="link", type="flash.events.TextEvent")]
	
	public class EditableTags extends EditableControl {
		
		protected static const LABEL : String = "Label";
		
		protected static const TEXT : String = "Text";
		
		protected static const TEXT_INPUT : String = "TextInput";
		
		protected static const TEXT_AREA : String = "TextArea";

		override public function get value() : Object {
			return tags.join(",");
		}
		
		override public function set value(value : Object) : void {
			tags = (value != null ? Objects.castToString(value).split(",") : []);
		}
		
		[Inspectable(enumeration="Label,Text")]
		public function get viewMode() : String {
			return _viewMode;
		}
		
		public function set viewMode(viewMode : String) : void {
			_viewMode = viewMode;
			_viewModeChanged = true;
			invalidateProperties();
		}
		
		[Inspectable(enumeration="TextInput,TextArea")]
		public function get editMode() : String {
			return _editMode;
		}
		
		public function set editMode(editMode : String) : void {
			_editMode = editMode;
			_editModeChanged = true;
			invalidateProperties();
		}
		
		public function get selectable() : Boolean {
			return _selectable;
		}
		
		public function set selectable(selectable : Boolean) : void {
			_selectable = selectable;
			_selectableChanged = true;
			invalidateProperties();
		}
		
		public function get clickable() : Boolean {
			return _clickable;
		}
		
		public function set clickable(clickable : Boolean) : void {
			_clickable = clickable;
			_clickableChanged = true;
			invalidateProperties();
		}
		
		public function get maxChars() : int  {
			return _maxChars;
		}
		
		public function set maxChars(maxChars : int) : void {
			_maxChars = maxChars;
			_maxCharsChanged = true;
			invalidateProperties();
		}
		
		[ArrayElementType("String")]
		public function get tags() : Array {
			return _tags;
		}
		
		public function set tags(tags : Array) : void {
			var tagCollection : ArrayCollection = new ArrayCollection();
			for (var i : int = 0; i < tags.length; i++) {
				var tag : String = StringUtil.trim(tags[i]);
				if (tag != "" && !tagCollection.contains(tag)) {
					tagCollection.addItem(tag);
				}
			}
			_tags = tagCollection.toArray();
			_tagsChanged = true;
			invalidateProperties();
		}
		
		[Inspectable(type="Color")]
		public function get tagsColor() : uint {
			return _tagsColor;
		}
		
		public function set tagsColor(tagsColor : uint) : void {
			_tagsColor = tagsColor;
			_tagsColorChanged = true;
			invalidateProperties();
		}
		
		public function get separator() : String {
			return _separator;
		}
		
		public function set separator(separator : String) : void {
			_separator = separator;
			_separatorChanged = true;
			invalidateProperties();
		}
		
		public function get defaultText() : String {
			return _defaultText;
		}
		
		public function set defaultText(defaultText : String) : void {
			_defaultText = defaultText;
			_defaultTextChanged = true;
			invalidateProperties();
		}
		public function get defaultTextFunctional() : Boolean {
			return _defaultTextFunctional;
		}
		
		public function set defaultTextFunctional(defaultTextFunctional : Boolean) : void {
			_defaultTextFunctional = defaultTextFunctional;
		}
		
		
		public function get showDefaultTextEverywhere() : Boolean {
			return _showDefaultTextEverywhere;
		}
		
		public function set showDefaultTextEverywhere(showDefaultTextEverywhere : Boolean) : void {
			_showDefaultTextEverywhere = showDefaultTextEverywhere;
			_showDefaultTextEverywhereChanged = true;
			invalidateProperties();
		}
		
		override protected function get empty() : Boolean {
			var result : Boolean;
			if (viewControl is Label) {
				result = Strings.isBlank(Label(viewControl).text);
			} else if (viewControl is Text) {
				result = Strings.isBlank(Text(viewControl).text);
			}
			return result;
		}
		
		protected function get tagsColorHex() : String {
			return ("#" + tagsColor.toString(16));
		}
		
		override public function save() : void {
			if (_showingDefaultText) {
				setEditControlText("");
			}
			super.save();
		}
		
		override public function cancel() : void {
			_tagsChanged = true;
			invalidateProperties();
			super.cancel();
		}
		
		override protected function commitProperties() : void {
			if (_viewModeChanged) {
				if (_viewMode == LABEL) {
					viewControl = new Label();
					viewControl.percentWidth = 100;
					viewControl.minWidth = 0;
				} else if (_viewMode == TEXT) {
					viewControl = new Text();
					//viewControl.regenerateStyleCache(false);
					viewControl.percentWidth = 100;
				}
				viewControl.addEventListener(FlexEvent.VALUE_COMMIT, onViewControlValueCommit);
				new EventRedispatcher(this).facadeEvents(viewControl, TextEvent.LINK);
				_tagsChanged = true;
				_selectableChanged = true;
				_viewModeChanged = false;
			}
			
			if (_editModeChanged) {
				if (_editMode == TEXT_INPUT) {
					editControl = new TextInput();
					editControl.percentWidth = 100;
				} else if (_editMode == TEXT_AREA) {
					editControl = new TextArea();
					editControl.percentWidth = 100;
					editControl.percentHeight = 100;
				}
				new EventRedispatcher(this).facadeEvents(editControl, Event.CHANGE, FlexEvent.ENTER, TextEvent.TEXT_INPUT);
				_tagsChanged = true;
				_maxCharsChanged = true;
				_editModeChanged = false;
				validator = new TagsValidator();
			}
			
			if (_selectableChanged) {
				if (viewControl is Label) {
					Label(viewControl).selectable = _selectable;
				} else if (viewControl is Text) {
					Text(viewControl).selectable = _selectable;
				}
				_selectableChanged = false;
			}
			
			if (_maxCharsChanged) {
				if (editControl is TextInput) {
					TextInput(editControl).maxChars = _maxChars;
				} else if (editControl is TextArea) {
					TextArea(editControl).maxChars = _maxChars;
				}
				_maxCharsChanged = false;
			}
			
			if (_tagsChanged || _tagsColorChanged || _clickableChanged || _separatorChanged
				|| _defaultTextChanged || _showDefaultTextEverywhereChanged) {
				
				if (_tagsChanged || _defaultTextChanged) {
					if (_tags.length == 0) {
						setEditControlText(_defaultText, true);
					} else {
						setEditControlText(getTagsText(false));
					}
				}
				
				if (_showDefaultTextEverywhere && _tags.length == 0) {
					if (viewControl is Label) {
						Label(viewControl).htmlText = _defaultText;
					} else if (viewControl is Text) {
						Text(viewControl).htmlText = _defaultText;
					}
				} else {
					if (viewControl is Label) {
						Label(viewControl).htmlText = getTagsText(true);
					} else if (viewControl is Text) {
						Text(viewControl).htmlText = getTagsText(true);
					}
				}
				
				_tagsChanged = false;
				_tagsColorChanged = false;
				_clickableChanged = false;
				_clickableChanged = false;
				_defaultTextChanged = false;
				_showDefaultTextEverywhereChanged = false;
			}
			
			super.commitProperties();
		}
		
		override protected function submitEditedValue() : void {
			if (editControl is TextInput) {
				tags = TextInput(editControl).text.split(",");
			} else if (editControl is TextArea) {
				tags = TextArea(editControl).text.split(",");
			}
			super.submitEditedValue();
		}
		
		override protected function onEditState() : void {
			editControl.setFocus();
			if (editControl is TextInput) {
				var textInputLength : int = TextInput(editControl).length;
				TextInput(editControl).setSelection(textInputLength, textInputLength);
			} else if (editControl is TextArea) {
				var textAreaLength : int = TextArea(editControl).length;
				TextArea(editControl).setSelection(textAreaLength, textAreaLength);
			}
		}
		
		override protected function focusInHandler(event : FocusEvent) : void {
			super.focusInHandler(event);
			if (editable && editControl != null && editControl.contains(DisplayObject(event.target))
				&& _showingDefaultText && !_defaultTextFunctional) {
				
				setEditControlText("");
			}
		}
		
		override protected function focusOutHandler(event : FocusEvent) : void {
			super.focusOutHandler(event);
			if (editable && editControl != null && editControl.contains(DisplayObject(event.target))
				&& !_defaultTextFunctional && Strings.isBlank(getEditControlText())) {
				
				setEditControlText(_defaultText, true);
			}
		}
		
		private function getTagsText(html : Boolean) : String {
			var result : String = "";
			for (var i : int = 0; i < tags.length; i++) {
				var tag : String = tags[i];
				result += (html ? getTagHTMLText(tag) : tag) + (i < tags.length - 1 ? (html ? separator : ", ") : "");
			}
			return result;
		}
		
		private function getTagHTMLText(tag : String) : String {
			var escapedTag : String = Strings.escapeSpecialCharacters(tag);
			var result : String =
				(clickable ?
					("<a href='event:" + escapedTag + "'><font color='" + tagsColorHex + "'><u>" + escapedTag + "</u></font></a>") :
						escapedTag);
			return result;
		}
		
		private function onViewControlValueCommit(event : FlexEvent) : void {
			dispatchEvent(new EditableControlEvent(EditableControlEvent.VIEW_CONTROL_VALUE_COMMIT));
		}
		
		private function getEditControlText() : String {
			if (editControl is TextInput) {
				return TextInput(editControl).text;
			} else if (editControl is TextArea) {
				return TextArea(editControl).text;
			}
			return null;
		}
		
		private function setEditControlText(text : String, isDefaultText : Boolean = false) : void {
			if (editControl is TextInput) {
				TextInput(editControl).text = text;
			} else if (editControl is TextArea) {
				TextArea(editControl).text = text;
			}
			_showingDefaultText = isDefaultText;
		}
		
		private var _viewMode : String = TEXT;
		
		private var _viewModeChanged : Boolean = true;
		
		private var _editMode : String = TEXT_AREA;
		
		private var _editModeChanged : Boolean = true;
		
		private var _selectable : Boolean = true;
		
		private var _selectableChanged : Boolean = true;
		
		private var _clickable : Boolean = true;
		
		private var _clickableChanged : Boolean;
		
		private var _maxChars : int;
		
		private var _maxCharsChanged : Boolean;
		
		private var _tags : Array = new Array();
		
		private var _tagsChanged : Boolean;
		
		private var _tagsColor : uint = 0x0000FF;
		
		private var _tagsColorChanged : Boolean;
		
		private var _separator : String = ", ";
		
		private var _separatorChanged : Boolean;
		
		private var _defaultText : String = "";
		
		private var _defaultTextChanged : Boolean;
		
		private var _showingDefaultText : Boolean;
		
		private var _defaultTextFunctional : Boolean;
		
		private var _showDefaultTextEverywhere : Boolean = true;
		
		private var _showDefaultTextEverywhereChanged : Boolean;
		
	}

}