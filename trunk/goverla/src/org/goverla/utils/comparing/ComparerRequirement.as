package org.goverla.utils.comparing
{
	import org.goverla.errors.IllegalStateError;
	import org.goverla.interfaces.IComparer;
	import org.goverla.interfaces.IRequirement;

	public class ComparerRequirement implements IRequirement
	{
		private var _comparer : IComparer;
		private var _objectToCompare : Object;
		private var _neededResults : Array;
		

		public function ComparerRequirement(comparer : IComparer, objectToCompare : Object, neededResults : Array) {
			for each(var neededResult : int in neededResults)
			{
				if(neededResult != ComparingResult.EQUALS 
					&& neededResult != ComparingResult.GREATER 
					&& neededResult != ComparingResult.SMALLER) {
						throw new IllegalStateError("neededResult must be in ComparingResult enumeration");
				}
			}
			_objectToCompare = objectToCompare;
			_comparer = comparer;
			_neededResults = neededResults;
		}
		
		
		public function meet(object:Object):Boolean
		{
			var comparingResult : int = _comparer.compare(getComparing(object), _objectToCompare);
			return _neededResults.indexOf(comparingResult) != -1;
		}
		
		protected function getComparing(source : Object) : Object {
			return source;
		}
		
	}
}