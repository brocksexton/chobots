package org.goverla.utils.comparing
{
	import org.goverla.collections.TypedArrayCollection;
	import org.goverla.interfaces.IRequirement;

	public class RequirementsCollection extends TypedArrayCollection implements IRequirement
	{
		public function RequirementsCollection(source : Array = null)
		{
			super(IRequirement, source);
		}
		
		public function meet(object:Object):Boolean
		{
			for each(var req : IRequirement in this) {
				if(! req.meet(object)) 
					return false;
			}
			
			return true;
		}
		
	}
}