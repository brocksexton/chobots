package org.goverla.utils.converting {

	import org.goverla.interfaces.IConverter;
	import org.goverla.utils.Objects;
	
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