package org.goverla.collections {
	
	import flash.events.EventDispatcher;
	
	import org.goverla.interfaces.IIterator;
	import org.goverla.interfaces.IStringMap;

	public class StringMap extends EventDispatcher implements IStringMap {
		
		public function get length() : int {
			return _hash.keys.length;
		}
		
		public function StringMap() {}
		
		public function valueIterator() : IIterator	{
			return _hash.valueIterator();
		}
		
		public function keyIterator() : IIterator	{
			return _hash.keyIterator();
		}		
		
		public function put(key : String, value : Object) : void {
			_hash.addItem(key, value);
		}

		public function get(key : String) : Object {
			return _hash.getItem(key);
		}
		
		public function clear() : void {
			_hash.clear();
		}
		
		public function containsKey(key : String) : Boolean {
			return _hash.containsKey(key);
		}
		
		public function containsItem(value : Object) : Boolean {
			return _hash.containsItem(value);
		}
		
		public function removeItemAt(key : String) : void {
			_hash.removeItemAt(key);
		}
		
		public function removeItem(value : Object) : void {
			_hash.removeItem(value);
		}
		
		private var _hash : HashMap = new HashMap();
	}
}