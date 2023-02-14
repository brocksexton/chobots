package com.kavalok.utils.comparing
{
	import com.kavalok.collections.ArrayList;
	import com.kavalok.interfaces.IRequirement;

	public class RequirementsCollection extends ArrayList implements IRequirement
	{
		public function RequirementsCollection()
		{
			super();
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