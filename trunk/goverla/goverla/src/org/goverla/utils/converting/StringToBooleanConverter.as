package org.goverla.utils.converting {

	import org.goverla.interfaces.IConverter;
	import org.goverla.errors.IllegalArgumentError;
	
//	import org.as2lib.env.except.IllegalArgumentException;
	
	/**
	 * @author Sergey Kovalyov
	 */
	public class StringToBooleanConverter implements IConverter {
		
		public function StringToBooleanConverter() {
		}
		
		public function convert(source : Object) : Object {

			var result : Boolean = false;
			if (source is String) {
				switch(source) { 
					case true.toString() :
						result = true; 
						break;
					case false.toString() : 
						result = false;
						break;
					default :
						throw new IllegalArgumentError("Argument 'source' [" + source + "] must equal either 'true' or 'false' string.");
				}
			} else {
				throw new IllegalArgumentError("Argument 'source' [" + source + "] must be string.");
			}
			return result;
		}
	
	}

}