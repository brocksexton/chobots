package org.goverla.utils.converting {
	
	import org.goverla.collections.ArrayList;
	import org.goverla.interfaces.IConverter;
	import org.goverla.utils.ReflectUtil;

	public class ObjectCopyConverter implements IConverter {
		
		public function ObjectCopyConverter(ignoredProperties : Array = null, includedProperties : Array = null) {
			if (ignoredProperties == null) {
				ignoredProperties = [];
			} 
			_ignoredProperties = new ArrayList(ignoredProperties);
			_includedProperties = includedProperties == null ? null : new ArrayList(includedProperties);
		}
		
		
		public function convert(source : Object) : Object {
			var type : Class = ReflectUtil.getType(source);
			var result : Object = new type();
			for each(var property : String in ReflectUtil.getFieldsAndPropertiesByInstance(source)) {
				if(!_ignoredProperties.contains(property) 
					&& (_includedProperties == null || _includedProperties.contains(property))) {
					result[property] = source[property];
				}
			}
			return result;
		}
		
		private var _ignoredProperties : ArrayList;
		
		private var _includedProperties : ArrayList;
		
	}
	
}