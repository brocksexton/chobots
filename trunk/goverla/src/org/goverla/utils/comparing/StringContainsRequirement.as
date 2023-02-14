package org.goverla.utils.comparing
{
	import org.goverla.interfaces.IRequirement;

	public class StringContainsRequirement implements IRequirement
	{
		private var _value : String;
		private var _caseSensitive : Boolean;
		
		public function StringContainsRequirement(value : String, caseSensitive : Boolean = false)
		{
			_value = value;
			_caseSensitive = caseSensitive;
		}
		
		public function meet(object:Object):Boolean
		{
			if(!(object is String))
				return false;
			if(_caseSensitive)
			{
				return (object as String).indexOf(_value) != -1;
			}
			else
			{
				return (object as String).toLowerCase().indexOf(_value.toLowerCase()) != -1;
			}
		}
		
	}
}