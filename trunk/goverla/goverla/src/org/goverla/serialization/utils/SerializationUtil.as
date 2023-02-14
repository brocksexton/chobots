package org.goverla.serialization.utils
{
	import org.goverla.serialization.constants.SerializationConstants;
	import org.goverla.utils.ReflectUtil;
	
	
	public class SerializationUtil
	{
		
		public static function createValueNode(typeAttribute : String, value : String) : XML {
			var result : XML = createEmptyNode(typeAttribute);
			return result.appendChild(new XML(value));
		}
		
		public static function createEmptyNode(typeAttribute : String) : XML {
			var result : XML = <root/>;
			result.@type = typeAttribute;
			return result;
		}

		public static function newInstance(node : XML) : Object {
			var typeName : String = node.@type;
			var type : Class = ReflectUtil.getTypeByName(typeName);
			return new type();
		}
	}
}