package org.goverla.utils.sorting {
	
	import mx.collections.ListCollectionView;
	
	import org.goverla.interfaces.IComparer;
	import org.goverla.interfaces.ISorter;
	import org.goverla.utils.comparing.ComparingResult;

	public class QuickSorter implements ISorter {
		
		public function sort(list : ListCollectionView, comparer : IComparer) : void {
			_list = list;
			_comparer = comparer;
			executeSort(0, list.length);
		}
		
		private function executeSort(begin : uint, length : uint) : void {
			  var i : Number = begin;
			  var j: Number = begin + length - 1; 
			  var currentElement : Object;
			  var temp : Object;
			  var centerIndex : uint = uint(begin + length/2);
			  currentElement = _list.getItemAt(centerIndex);
			
			  do {
			    while (_comparer.compare(_list.getItemAt(i), currentElement) == ComparingResult.SMALLER) i++;
			    while (_comparer.compare(_list.getItemAt(j), currentElement) == ComparingResult.GREATER) j--;
			
			    if (i <= j) {
			      temp = _list.getItemAt(i); 
			      _list.setItemAt(_list.getItemAt(j), i);
			      _list.setItemAt(temp, j);
			      i++; j--;
			    }
			  } while ( i<=j );
			
			
			  if ( j > begin ) executeSort(begin, j - begin + 1);
			  if ( begin + length > i ) executeSort(i, begin + length - i);
		}
		
		private var _list : ListCollectionView;
		
		private var _comparer : IComparer;
		
	}
	
}