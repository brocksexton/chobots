package org.goverla.utils.comparing
{
	import org.goverla.interfaces.IRequirement;
	import org.goverla.utils.Objects;

	public class XmlAttributeRequirement implements IRequirement
	{
		private var _name : String;
		private var _value : String;
		
		public function XmlAttributeRequirement(name : String, value : String) {
			_name = name;
			_value = value;
		}
		
		public function meet(object:Object):Boolean
		{
			var xml : XML = Objects.castToXML(object);
			return xml["@"+_name].toString() == _value;
		}
		
	}
}