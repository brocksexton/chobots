package com.kavalok.collections {
	
	import com.kavalok.interfaces.IComparer;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.Maths;
	import com.kavalok.utils.sorting.QuickSorter;
	
	import flash.net.registerClassAlias;
	
	[RemoteClass(alias="com.kavalok.collections.ArrayList")]
	public dynamic class ArrayList extends Array {
		
		public static function initialize() : void {
			registerClassAlias("com.kavalok.collections.ArrayList", ArrayList);
		}
		
		public function get last() : * {
			return getItemAt(length - 1);
		}
		
		public function get random() : * {
			return getItemAt(Maths.random(length));
		}
		
		public function get first() : * {
			return getItemAt(0);
		}

		public function ArrayList(source : Array = null) {
			super();
			if(source)
			{
				for each(var item : Object in source)
					push(item);
			}
		}
		
		public function getItemIndices(item : Object) : ArrayList {
			var result : ArrayList = new ArrayList();
			for (var i : uint = 0; i < length; i++) {
				if (getItemAt(i) == item) {
					result.addItem(i);
				}
			}
			return result;
		}
		
		public function clone() : Object {
			var result : ArrayList = new ArrayList();
			result.addItems(this);
			return result;
		}

		public function addItems(source : Array) : void {
			Arrays.insertAll(this, source);
		}
		
		public function getItemAt(index : uint) : *
		{
			return this[index];
		}
		
		public function addItemAt(index : uint, item : Object) : void
		{
			splice(index, 0, item);
		}
		public function addItem(item : Object) : void
		{
			push(item);
		}
		
		public function contains(item : Object) : Boolean
		{
			return indexOf(item) != -1;
		}
		
		public function addFirst(item : Object) : void {
			unshift(item);
		}
		
		public function addLast(item : Object) : void {
			addItem(item);
		}
		
		public function removeItemAt(index : uint) : Object
		{
			return splice(index, 1)[0];
		}
		
		public function removeFirst() : * {
			return removeItemAt(0);
		}

		public function removeLast() : * {
			return removeItemAt(this.length - 1);
		}
		
		public function removeItems(items : Array) : void {
			for each(var item : Object in items)
				removeItem(item);
		}

		public function getItemIndex(item : Object) : int {
			return indexOf(item);
		}
		
		
		public function setItemAt(item : Object, index : uint) : * {
			var result : * = this[index];
			this[index] = item;
			return result;
		}
		public function removeItem(item : Object) : void {
			removeItemAt(indexOf(item));
		}
		
		public function subList(beginIndex : int, count : int) : Array {
			return slice(beginIndex, beginIndex + count);
		}
		
		public function retainItems(items : ArrayList) : void {
			var i : int = 0;
			while (i < length && length > 0) {
				if (items.contains(getItemAt(i))) {
					i++;
				} else{
					removeItemAt(i);
				}
			} 
		}
		
		public function replaceItem(item : Object, newItem : Object) : void {
			var index : uint = indexOf(item);
			this[index] = newItem;
		}
		
		public function replaceItems(firstIndex : int, secondIndex : int) : void {
			Arrays.replaceItems(this, firstIndex, secondIndex);
		}
		
		public function setItems(list : Array, beginIndex : int) : void {
			if (beginIndex < 0 || list.length > (length - beginIndex)) {
				throw new RangeError("Argument 'beginIndex' [" + beginIndex + "] is out of range, this is less than 0 or the 'beginIndex' plus the length of the given 'list' [" + list.length + "] is greater than this ArrayList's length [" + length + "].");
			}
			
			var i : int = beginIndex;
			for each(var item : Object in list) {
				this[i++] = item;
			}
		}
		
		public function containsItems(items : Array) : Boolean {
			var result : Boolean = true;
			
			for each(var item : Object in items) {
				if (!contains(item)) {
					result = false;
					break;
				}
			}
			
			return result;
		}
		
		public function sortBy(comparer : IComparer) : void {
			new QuickSorter().sort(this, comparer);
		}

	}
	
}