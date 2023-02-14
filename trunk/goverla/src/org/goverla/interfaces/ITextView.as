package org.goverla.interfaces {
	
	public interface ITextView extends IText {
		
		function get selectable() : Boolean;
		
		function set selectable(value : Boolean) : void;
		
	}
}