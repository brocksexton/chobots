package org.goverla.utils.comparing
{
	import org.goverla.interfaces.IRequirement;

	public class NotEqualsRequirement extends NotRequirement
	{
		public function NotEqualsRequirement(value : Object)
		{
			super(new EqualsRequirement(value));
		}
		
	}
}