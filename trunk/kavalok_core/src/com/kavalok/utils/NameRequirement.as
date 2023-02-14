package com.kavalok.utils
{
	import com.kavalok.interfaces.IRequirement;

	public class NameRequirement implements IRequirement
	{
		private var _name:String;
		private var _prefixMode:Boolean;
		
		public function NameRequirement(name:String, prefixMode:Boolean = false)
		{
			_name = name;
			_prefixMode = prefixMode;
		}

		public function meet(object:Object):Boolean
		{
			if (_prefixMode)
				return (String(object.name).indexOf(_name) == 0);
			else
				return (object.name == _name);
		}
		
	}
}