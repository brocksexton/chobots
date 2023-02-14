package org.goverla.utils.comparing
{
	import org.goverla.collections.ArrayList;
	import org.goverla.interfaces.IRequirement;

	public class UniqueItemRequirement implements IRequirement
	{
		private var _values : ArrayList = new ArrayList();
		
		public function UniqueItemRequirement()
		{
			super();
		}

		public function meet(object:Object):Boolean
		{
			var result : Boolean = !_values.contains(getValue(object));
			if (result) {
				_values.addItem(getValue(object));
			}
			return result;
		}
		
		protected function getValue(source : Object) : Object
		{
			return source;
		}
		
	}
}