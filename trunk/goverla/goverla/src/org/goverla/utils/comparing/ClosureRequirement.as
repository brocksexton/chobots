package org.goverla.utils.comparing
{
	import org.goverla.interfaces.IRequirement;

	public class ClosureRequirement implements IRequirement
	{
		private var _closure : Function;
		
		public function ClosureRequirement(closure : Function)
		{
			_closure = closure;
		}
		
		public function meet(object:Object):Boolean
		{
			return _closure(object);
		}
		
	}
}