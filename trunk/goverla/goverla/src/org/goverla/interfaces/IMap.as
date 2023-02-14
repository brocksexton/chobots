package org.goverla.interfaces {
	
	import mx.collections.ArrayCollection;

	public interface IMap {
		
		function get keys() : ArrayCollection;

		function get values() : ArrayCollection;
		
		function addItem(key : Object, value : Object) : void;

		function removeItemAt(key : Object) : void;
		
		function getItem(key : Object) : Object;
		
		function clear() : void;
		
		function valueIterator() : IIterator;
		
		function keyIterator() : IIterator;
		
		function containsKey(key : Object) : Boolean;
		
	}
	
}