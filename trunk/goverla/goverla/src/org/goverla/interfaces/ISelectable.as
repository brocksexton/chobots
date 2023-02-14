package org.goverla.interfaces {
	
	public interface ISelectable extends IMultipage {
		
		function get selectedIndex() : Number;
		
		function set selectedIndex(index : Number) : void;
		
		function get selectedItem() : Object;
		
		function set selectedItem(value : Object) : void;
		
	}
}