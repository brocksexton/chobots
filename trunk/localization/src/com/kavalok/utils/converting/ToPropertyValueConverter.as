package com.kavalok.utils.converting {

	import com.kavalok.interfaces.IConverter;
	import com.kavalok.utils.Objects;
	
	/**
	 * @author Maxym Hryniv
	 */
	public class ToPropertyValueConverter implements IConverter {
		
		private var _propertyName : String;
		
		public function ToPropertyValueConverter(propertyName : String) {
			_propertyName = propertyName;
		}
		
		public function convert(source : Object) : Object {
			return Objects.getProperty(source, _propertyName);
		}
	
	}

}