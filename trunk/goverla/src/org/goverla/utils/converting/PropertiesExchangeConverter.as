package org.goverla.utils.converting {
	
	import mx.utils.ObjectUtil;
	
	import org.goverla.interfaces.IConverter;

	public class PropertiesExchangeConverter implements IConverter {
		
		public function PropertiesExchangeConverter(firstProperty : String, secondProperty : String) {
			_firstProperty = firstProperty;
			_secondProperty = secondProperty
		}
		
		public function convert(source : Object) : Object {
			var result : Object = ObjectUtil.copy(source);
			var temp : Object = result[_firstProperty];
			result[_firstProperty] = result[_secondProperty];
			result[_secondProperty] = temp;
			return result;
		}
		
		private var _firstProperty : String;
		
		private var _secondProperty : String;
		
	}
	
}