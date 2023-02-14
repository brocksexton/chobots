package org.goverla.utils.converting {
	
	import org.goverla.interfaces.IConverter;

	public class ObjectToEntryConverter implements IConverter {
		
		public function ObjectToEntryConverter(type : Class) {
			_type = type;
		}
		
		public function convert(source : Object) : Object {
			var result : Object = new _type();
			for (var property : String in source) {
				result[property] = source[property];
			}
			return result;
		}
		
		private var _type : Class;
		
	}
	
}