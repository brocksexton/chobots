package org.goverla.utils.comparing {

	import org.goverla.interfaces.IRequirement;
	
	/**
	 * @author Sergey Kovalyov
	 */
	public class NotRequirement implements IRequirement {
		
		private var _requirement : IRequirement;
		
		public function NotRequirement(requirement : IRequirement) {
			_requirement = requirement;
		}
		
		public function meet(object : Object) : Boolean {
			return !_requirement.meet(object);
		}
	
	}

}