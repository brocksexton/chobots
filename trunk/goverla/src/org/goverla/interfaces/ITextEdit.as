package org.goverla.interfaces {
	
	public interface ITextEdit extends IText {
		
		function get defaultText() : String;
		
		function set defaultText(value : String) : void;
		
		function setSelection(beginIndex : int, endIndex : int) : void;
		
		function get maxChars() : int;
		
		function set maxChars(value : int) : void;
		
		function get restrict() : String;
		
		function set restrict(value : String) : void;
		
	}
}