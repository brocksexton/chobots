package org.goverla.utils.converting {
	
	import org.goverla.interfaces.IConverter;
	import org.goverla.utils.Objects;

	public class XMLListToArrayConverter implements IConverter {
		
		public function convert(source : Object) : Object {
			var result : Array = new Array();
			var list : XMLList = Objects.castToXMLList(source);
			for (var i : uint = 0; i < list.length(); i++) {
				result.push(list[i]);
			} 
			return result;
		}
		
	}
	
}