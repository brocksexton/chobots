package org.goverla.collections {
	
	import mx.collections.ArrayCollection;
	
	import org.goverla.interfaces.IIterator;
	import org.goverla.interfaces.IMap;
	
	public class HashMap implements IMap {
		
		public function get keys() : ArrayCollection {
			return _keys;
		}

		public function get values() : ArrayCollection {
			return _values;
		}
		
		public function addItem(key : Object, value : Object) : void {
			if (_keys.contains(key)) {
				_values.setItemAt(value, _keys.getItemIndex(key))
			} else {
				_keys.addItem(key);
				_values.addItem(value);
			}
		}
		
		public function removeItemAt(key : Object) : void {
			var index : int = _keys.getItemIndex(key);
			_keys.removeItemAt(index);
			_values.removeItemAt(index);
		}
		
		public function removeItem(value : Object) : void {
			var index : int = _values.getItemIndex(value);
			_keys.removeItemAt(index);
			_values.removeItemAt(index);
		}		
		
		public function getItem(key : Object) : Object {
			var index : int = _keys.getItemIndex(key);
			return (index > -1) ? _values.getItemAt(index) : null;	
		}

		public function valueIterator() : IIterator {
			return new ListCollectionViewIterator(_values);
		}

		public function keyIterator() : IIterator {
			return new ListCollectionViewIterator(_keys);
		}
		
		public function clear() : void {
			_keys.removeAll();
			_values.removeAll();
		}
		
		public function containsKey(key : Object) : Boolean {
			return _keys.contains(key);
		}
		
		public function containsItem(value : Object) : Boolean {
			return _values.contains(value);
		}

		private var _keys : ArrayCollection = new ArrayCollection();
		
		private var _values : ArrayCollection = new ArrayCollection();		

	}
	
}