package org.goverla.interfaces {

	public interface IBindableMultipleSelectionList extends IBindableList {

		function get selectedIndices() : Array;
		
		function set selectedIndices(selectedIndices : Array) : void;
		
		function get selectedItems() : Array;
		
		function set selectedItems(selectedItems : Array) : void;
		
	}

}