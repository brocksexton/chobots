package com.kavalok.utils {
	import flash.utils.getQualifiedClassName;
	
	
	public class Objects {
		
        public static const TYPE_NUMBER : String = "number";

        public static const TYPE_STRING : String = "string";

        public static const TYPE_BOOLEAN : String = "boolean";

        public static const TYPE_OBJECT : String = "object";

        public static const TYPE_NULL : String = "null";

		public static const TRUE_STRING : String = "true";
		
		public static const FALSE_STRING : String = "false";
		
		public static function getFieldName(field : String) : String {
			var path : Array = field.split(".");
			var result : String = path[path.length - 1];
			return result;
		}	
		
		public static function getProperty(context : Object, field : String) : Object {
			var path : Array = field.split(".");
			var result : Object = context;
			for each (var propertyName : String in path) {
				result = result[propertyName];
			}
			return result;
		}	
		
		public static function getPropertiesCount(source : Object) : Number {
			var result : Number = 0;
			for (var p : String in source) {
				result++;
			} 
			return result;
		}
		
		public static function isSet(source : Object) : Boolean {
			return (source != null);
		}

		public static function isPrimitive(source : Object) : Boolean {
			var type : String = typeof(source);
			return (type == TYPE_NUMBER || type == TYPE_BOOLEAN || type == TYPE_STRING || source is Class);
		}
		
		public static function isPrimitiveClassName(className : String) : Boolean {
			var type : String = className.toLowerCase();
			return type == TYPE_NUMBER || type == TYPE_BOOLEAN || type == TYPE_STRING;
		}
		
		public static function parseToRightType(source : Object) : Object {
			if (source is String) {
				if (source.toLowerCase() == "true") {
					return true;
				} else if (source.toLowerCase() == "false") {
					return false;
				} else {
					return source;			
				}
			} else {
				return source;
			}
		}
		
	    public static function isSimple(value:Object):Boolean
	    {
	        var type:String = typeof(value);
	        switch (type)
	        {
	            case "number":
	            case "string":
	            case "boolean":
	            {
	                return true;
	            }
	
	            case "object":
	            {
	                return (value is Date) || (value is Array);
	            }
	        }
	
	        return false;
	    }
		public static function castToString(object : Object) : String {
			return castToType(object, String) as String;
		}
		
		public static function castToNumber(object : Object) : Number {
			return castToType(object, Number) as Number;
		}

		public static function castToInt(object : Object) : Number {
			return castToType(object, Number) as int;
		}
		
		public static function castToArray(object : Object) : Array {
			return castToType(object, Array) as Array;
		}
		
		public static function castToBoolean(object : Object) : Boolean {
			return castToType(object, Boolean) as Boolean;
		}
		
		public static function castToDate(object : Object) : Date {
			return castToType(object, Date) as Date;
		}

		public static function castToFunction(object : Object) : Function {
			return castToType(object, Function) as Function;
		}

		public static function castToXML(object : Object) : XML {
			return castToType(object, XML) as XML;
		}

		public static function castToXMLList(object : Object) : XMLList {
			return castToType(object, XMLList) as XMLList;
		}

		public static function castToClass(object : Object) : Class {
			return castToType(object, Class) as Class;
		}
		
		private static function castToType(object : Object, type : Class) : Object {
			if (object is type || object == null) {
				return object as type;
			} else {
				throw TypeError("[" + getQualifiedClassName(new type()) + "] was expected but [" + 
					getQualifiedClassName(object) + "] was found");
			}
		}
		
	}

}