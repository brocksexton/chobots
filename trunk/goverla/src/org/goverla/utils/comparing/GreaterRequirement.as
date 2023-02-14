package org.goverla.utils.comparing
{
	import org.goverla.interfaces.IComparer;

	public class GreaterRequirement extends ComparerRequirement
	{
		public function GreaterRequirement(comparer:IComparer, objectToCompare:Object)
		{
			super(comparer, objectToCompare, [ComparingResult.GREATER]);
		}
		
	}
}