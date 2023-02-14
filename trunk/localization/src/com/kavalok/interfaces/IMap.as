package com.kavalok.interfaces {
	
	import com.kavalok.collections.ArrayList;

	public interface IMap {
		
		function get keys() : ArrayList;

		function get values() : ArrayList;
		
		function addItem(key : Object, value : Object) : void;

		function removeItemAt(key : Object) : void;
		
		function getItem(key : Object) : Object;
		
		function clear() : void;
		
		function valueIterator() : IIterator;
		
		function keyIterator() : IIterator;
		
		function containsKey(key : Object) : Boolean;
		
	}
	
}