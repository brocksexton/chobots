package com.kavalok.utils.comparing
{
	import com.kavalok.interfaces.IRequirement;
	
	import flash.utils.getQualifiedClassName;

	public class ClassNameRequirement implements IRequirement
	{
		private var _className : String;
		
		public function ClassNameRequirement(className : String)
		{
			_className = className;
		}

		public function meet(object:Object):Boolean
		{
			return getQualifiedClassName(object) == _className;
		}
		
	}
}