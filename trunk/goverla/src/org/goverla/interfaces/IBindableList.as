package org.goverla.interfaces {

	public interface IBindableList {
		
		function get dataProvider() : Object;
		
		function set dataProvider(dataProvider : Object) : void;
		
		function get selectedIndex() : int;
		
		function set selectedIndex(selectedIndex : int) : void;
		
		function get selectedItem() : Object;
		
		function set selectedItem(selectedItem : Object) : void;
		
	}

}