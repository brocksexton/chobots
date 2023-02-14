package org.goverla.utils.comparing
{
	import org.goverla.interfaces.IRequirement;

	public class EqualsRequirement implements IRequirement
	{
		private var _value : Object;
		
		public function EqualsRequirement(value : Object) {
			_value = value;
		}
		
		public function meet(object:Object):Boolean
		{
			return _value == object;
		}
		
	}
}