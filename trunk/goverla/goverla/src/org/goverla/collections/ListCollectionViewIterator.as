package org.goverla.collections {

	import mx.collections.ListCollectionView;
	
	import org.goverla.interfaces.IIterator;
	
	public class ListCollectionViewIterator implements IIterator {

		private var _source : ListCollectionView;

		private var _currentIndex : int = 0;
		
		public function ListCollectionViewIterator(source : ListCollectionView) {
			_source = source;
		}
		
		public function hasNext() : Boolean {
			return _source.length > _currentIndex;
		}
		
		public function next() : Object {
			var result : Object = _source.getItemAt(_currentIndex);
			_currentIndex++;
			return result;
		}
		
	}

}