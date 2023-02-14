package org.goverla.utils.converting {
	
	import org.goverla.interfaces.IConverter;
	import org.goverla.utils.Objects;

	public class ToMethodResultConverter implements IConverter {
		
		private var _methodName : String;
	
		private var _arguments : Array;
		
		public function ToMethodResultConverter(methodName : String, args : Array = null) {
			_methodName = methodName;
			_arguments = args;
		}
		
		public function convert(source : Object) : Object {
			var method : Function = Objects.castToFunction(source[_methodName]);
			return method.apply(source, _arguments);
		}
	
	}
}