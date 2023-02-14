package org.goverla.utils.comparing
{
	import org.goverla.interfaces.IComparer;
	import org.goverla.utils.Objects;

	public class PropertyComparerRequirement extends ComparerRequirement
	{
		private var _property : String;
		
		public function PropertyComparerRequirement(property : String, comparer:IComparer, objectToCompare:Object, neededResults:Array)
		{
			super(comparer, objectToCompare, neededResults);
			_property = property;
		}
		
		override protected function getComparing(source:Object):Object {
			return Objects.getProperty(source, _property);
		}
		
		
		
	}
}