package org.goverla.utils.common {
	
	public class Pair {
		
        public static const empty : Pair = new Pair(null, null);
        
        public var name : String;
        
        public var value : Object;

		public function Pair(name : String, value : Object) {
			this.name = name;
			this.value = value;
		}
	}
}