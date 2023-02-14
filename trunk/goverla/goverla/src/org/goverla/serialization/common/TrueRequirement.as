package org.goverla.serialization.common
{
	import org.goverla.interfaces.IRequirement;

	public class TrueRequirement implements IRequirement
	{
		public function meet(object:Object):Boolean
		{
			return true;
		}
		
	}
}