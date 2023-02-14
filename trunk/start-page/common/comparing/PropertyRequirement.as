package common.comparing
{
	
	/**
	* ...
	* @author Canab
	*/
	public class PropertyRequirement implements IRequirement
	{
		private var _property:String;
		private var _value:Object;
		
		public function PropertyRequirement(property:String, value:Object)
		{
			_property = property;
			_value = value;
		}
		
		public function accept(object:Object):Boolean
		{
			return (object[_property] == _value);
		}
		
	}
}