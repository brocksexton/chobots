package org.goverla.utils.comparing
{
	import org.goverla.interfaces.IComparer;

	public class GreaterOrEqualsRequirement extends ComparerRequirement
	{
		public function GreaterOrEqualsRequirement(comparer:IComparer, objectToCompare:Object)
		{
			super(comparer, objectToCompare, [ComparingResult.GREATER, ComparingResult.EQUALS]);
		}
		
	}
}