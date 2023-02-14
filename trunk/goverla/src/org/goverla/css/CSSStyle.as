package org.goverla.css
{
	import mx.styles.StyleManager;
	import org.goverla.utils.Objects;
	import mx.utils.StringUtil;
	
	public class CSSStyle {
		private static const FORMAT : String = "{0}:{1};"
		
		private var _name : String;
		private var _value : Object;
		
		public function CSSStyle(name : String, value : Object = null) {
			_name = name;
			_value = value;
		}
		
		public function get name() : String {
			return _name;
		}

		public function get value() : Object {
			return _value;
		}

		public function set value(value : Object) : void {
			_value = value;
		}
		
		public function toString() : String {
			if(value == null)
				return "";
			var resultValue : String = "";
			if(value is Array) {
				var values : Array = Objects.castToArray(value);
				for(var i : int = 0; i < values.length - 1; i++) {
					resultValue += values[i].toString() + ", ";
				}
				resultValue += values[i].toString();
			} else {
				resultValue = value.toString(); 
			}
			
			return StringUtil.substitute(FORMAT, name, resultValue);
		}
	}
}