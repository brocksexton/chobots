package org.goverla.controls {
	
	import flash.events.Event;
	
	import mx.controls.TextArea;
	import mx.core.IUITextField;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;

	public class SizableTextArea extends TextArea {
		
		public override function set minHeight(value : Number) : void {
			super.minHeight = value;
			_minHeightChanged = true;
			invalidateProperties();
		}
		
		public override function set maxHeight(value : Number) : void {
			super.maxHeight = value;
			if (!isNaN(value) && value != 0) {
				verticalScrollPolicy = ScrollPolicy.AUTO;
			}
			_maxHeightChanged = true;
			invalidateProperties();
		}
		
		public override function set text(value : String) : void {
			_textChanged = true;
			if (!_creationComplete) {
				_text = value;
			} else {
				super.text = value;
				invalidateProperties();
			}
		}
		
		public override function setActualSize(w : Number, h : Number) : void {
			super.setActualSize(w, h);
			simulateTextChange();
			refreshHeight();
		}
		
		public function get internalTextField() : IUITextField
		{
			return textField;
		}
		
		public function SizableTextArea() {
			super();
			addEventListener(Event.CHANGE, onChange);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			verticalScrollPolicy = ScrollPolicy.OFF;
		}
		
		protected override function commitProperties() : void
		{
			super.commitProperties();

			if (_minHeightChanged || _maxHeightChanged || _textChanged) {
				_minHeightChanged = false;
				_maxHeightChanged = false;
				_textChanged = false;
				refreshHeight();
			}
		}
		
		public function refreshHeight() : void {
			var newHeight : int = Math.max(textHeight + 10, minHeight);
			if (!isNaN(maxHeight) && maxHeight != 0) {
				height = Math.min(newHeight, maxHeight);
			}
			else
			{
				height = newHeight;
			}
		}
		
		public function simulateTextChange() : void {
			if (text != "") {
				if (text.charAt(text.length - 1) == " ") {
					text = text.substr(0, text.length - 1);
				} else {
					text += " ";
				}
			}
		}
		
		private function onChange(event : Event) : void {
			refreshHeight();
		}
		
		private function onCreationComplete(event : FlexEvent) : void {
			_creationComplete = true;
			if (_text != null) {
				text = _text;
			}
		}
		
		private var _minHeightChanged : Boolean;
		
		private var _maxHeightChanged : Boolean;
		
		private var _textChanged : Boolean;
		
		private var _text : String;
		
		private var _creationComplete : Boolean;
		
	}
	
}