package com.kavalok.interfaces {
	
	
	import com.kavalok.collections.ArrayList;
	
	public interface ISorter {
		
		function sort(list : ArrayList, comparer : IComparer) : void;
		
	}
	
}