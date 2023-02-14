package org.goverla.interfaces {

	public interface IComparer {
	
		/**
		 * @return ComparingResult.EQUALS if objects are equals, ComparingResult.GREATER if obj1 > obj2, othervise ComparingResult.SMALLER
		 */
		function compare(object1 : Object, object2 : Object) : int;
		
	}
	
}