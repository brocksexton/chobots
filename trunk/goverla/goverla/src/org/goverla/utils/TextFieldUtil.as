package org.goverla.utils
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.controls.TextArea;
	import mx.core.mx_internal;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.reflection.Overload;
	
	use namespace mx_internal;
	
	public final class TextFieldUtil
	{
		public static function getCharactersFormat(textField : TextField, begin : uint, end : uint) : ArrayList {
			var result : ArrayList = new ArrayList();
			for(var i : uint = begin; i < end; i++) {
				result.addItem(textField.getTextFormat(i, i + 1));
			}
			return result;

		}
		
		public static function getTextField(textArea : TextArea) : TextField {
			return TextField(textArea.getTextField());
		}
		
		public static function setCharactersFormat(textComponent : Object, begin : uint, formats : ArrayList) : void {
			var overload : Overload = new Overload(TextFieldUtil);
			overload.addHandler([TextArea, uint, ArrayList], setCharactersFormatForArea);
			overload.addHandler([TextField, uint, ArrayList], setCharactersFormatForField);
			overload.forward(arguments);

		}		
		
		public static function setCharactersFormatForArea(textArea : TextArea, begin : uint, formats : ArrayList) : void {
			setCharactersFormatForField(getTextField(textArea), begin, formats);
		}

		public static function setCharactersFormatForField(textField : TextField, begin : uint, formats : ArrayList) : void {
			for(var i : uint = 0; i < formats.length; i++) {
				textField.setTextFormat(TextFormat(formats.getItemAt(i)), begin + i, begin + i + 1);
			}

		}
	}
}