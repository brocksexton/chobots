package org.goverla.interfaces {
	
	public interface IText {
		
		function get text() : String;
		
		function set text(value : String) : void;
		
		function get htmlText() : String;
		
		function set htmlText(value : String) : void;
		
		function get empty() : Boolean;
		
		function get length() : int;
		
	}
}