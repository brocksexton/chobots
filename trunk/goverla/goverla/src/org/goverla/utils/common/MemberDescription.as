package org.goverla.utils.common {
	
	public class MemberDescription {
		
		private var _name : String;
		private var _clazz : Class;
		
		public function MemberDescription(name : String, clazz : Class) {
			_name = name;
			_clazz = clazz;
		}
		
		public function get name() : String {
			return _name;
		}

		public function get clazz() : Class {
			return _clazz;
		}
		
	}
	
}