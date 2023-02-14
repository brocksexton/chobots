package org.goverla.serialization.serializers.requirements
{
	import org.goverla.interfaces.IRequirement;

	public class TypeOfRequirement implements IRequirement
	{
		private var _type : String;
		
		public function TypeOfRequirement(type : String) {
			_type = type;
		}
		
		public function meet(object:Object):Boolean
		{
			return typeof(object) == _type;
		}
		
	}
}