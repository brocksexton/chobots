package com.kavalok.utils.comparing
{
	import com.kavalok.interfaces.IRequirement;

	public class ClassRequirement implements IRequirement
	{
		private var _class : Class;
		
		public function ClassRequirement(clazz : Class) {
			_class = clazz;
		}
		
		public function get clazz() : Class {
			return _class;
		}
		
		public function set clazz(value : Class) : void {
			_class = value;
		}
		
		
		public function meet(object:Object):Boolean
		{
			return object is _class;
		}
		
	}
}