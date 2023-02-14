package common.comparing
{
	
	/**
	* ...
	* @author canab
	*/
	public class TypeRequirement implements IRequirement
	{
		private var _type:Class;
		
		public function TypeRequirement(type:Class)
		{
			_type = type;
		}
		
		public function accept(object:Object):Boolean
		{
			return object is _type;
		}
		
	}
}