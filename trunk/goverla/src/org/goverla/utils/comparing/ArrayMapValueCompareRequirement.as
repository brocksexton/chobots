package org.goverla.utils.comparing {

	import mx.collections.ArrayCollection;
	
	import org.goverla.interfaces.IMap;
	import org.goverla.interfaces.IRequirement;
	
	/**
	 * @author Tyutyunnyk Eugene
	 */
	public class ArrayMapValueCompareRequirement implements IRequirement {
		
		private var _map : IMap;
		
		private var _value : Object;
		
		public function ArrayMapValueCompareRequirement(map : IMap, value : Object) {
			_map = map;
			_value = value;
		}
		
		public function meet(object : Object) : Boolean {
			var arrayValue : ArrayCollection = ArrayCollection(_map.getItem(object));
			return arrayValue.contains(_value);
		}
	
	}

}