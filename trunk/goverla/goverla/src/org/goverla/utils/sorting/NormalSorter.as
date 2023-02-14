package org.goverla.utils.sorting {
	
	import mx.collections.ListCollectionView;
	
	import org.goverla.interfaces.IComparer;
	import org.goverla.interfaces.ISorter;
	import org.goverla.utils.comparing.ComparingResult;

	public class NormalSorter implements ISorter {
		
		public function sort(list : ListCollectionView, comparer : IComparer) : void {
			for (var i : uint = 0; i < list.length; i++) {
				var minimum : Object = list.getItemAt(i);
				var minimumIndex : uint = i;
				
				for(var j : uint = i; j < list.length; j++) {
					if(comparer.compare(list.getItemAt(j), minimum) == ComparingResult.SMALLER) {
						minimum = list.getItemAt(j);
						minimumIndex = j;
					} 
				}
				
				if (i != minimumIndex) {
					list.setItemAt(list.getItemAt(i), minimumIndex);
					list.setItemAt(minimum, i);
				}
			}
		}
		
	}
	
}