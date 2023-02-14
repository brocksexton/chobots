package org.goverla.utils.comparing {
	
	import mx.utils.StringUtil;
	
	import org.goverla.errors.IllegalStateError;
	import org.goverla.interfaces.IComparer;

	public class ValueComparer implements IComparer {
		
		public function compare(object1 : Object, object2 : Object) : int {
			if (object1 < object2) 
				return ComparingResult.SMALLER;
			
			if (object1 > object2) 
				return ComparingResult.GREATER;
			
			if(object1 == object2) 
				return ComparingResult.EQUALS;
			
			throw new IllegalStateError(StringUtil.substitute("Cannot compare object {0} with {1}", object1, object2));
		}
		
	}
	
}