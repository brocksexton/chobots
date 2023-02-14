package com.kavalok.utils
{
	import com.kavalok.interfaces.IRequirement;

	public class TypeRequirement implements IRequirement
	{
		private var _type:Class;
		
		public function TypeRequirement(type:Class)
		{
			_type = type;
		}

		public function meet(object:Object):Boolean
		{
			return (object is _type);
		}
		
	}
}