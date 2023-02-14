package org.goverla.utils.comparing {
	
	import org.goverla.errors.IllegalStateError;
	import org.goverla.interfaces.IComparer;

	public class NotComparer implements IComparer {
		
		public function NotComparer(comparer : IComparer) {
			_comparer = comparer;	
		}
		
		public function compare(object1 : Object, object2 : Object) : int {
			var result : int = _comparer.compare(object1, object2);
			if (result == ComparingResult.GREATER) 
				return ComparingResult.SMALLER;
			if (result == ComparingResult.SMALLER) 
				return ComparingResult.GREATER;
			if (result == ComparingResult.EQUALS) 
				return ComparingResult.EQUALS;
			throw new IllegalStateError("Unknown comparing result");
		}
		
		private var _comparer : IComparer;
		
	}
	
}