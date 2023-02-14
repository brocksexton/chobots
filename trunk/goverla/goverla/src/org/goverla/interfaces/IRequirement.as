package org.goverla.interfaces {
	
	public interface IRequirement {
	
		/**
		 * @return true if object meets the requirement
		 */
		function meet(object : Object) : Boolean;
	
	}

}