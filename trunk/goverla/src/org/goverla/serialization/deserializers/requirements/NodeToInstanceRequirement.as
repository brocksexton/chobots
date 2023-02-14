package org.goverla.serialization.deserializers.requirements
{
	import org.goverla.interfaces.IRequirement;
	import org.goverla.serialization.utils.SerializationUtil;
	
	

	public class NodeToInstanceRequirement implements IRequirement
	{
		private var _instanceRequirement : IRequirement;
		
		public function NodeToInstanceRequirement(instanceRequirement : IRequirement) {
			_instanceRequirement = instanceRequirement;
		}
		
		public function meet(object:Object):Boolean
		{
			var result : Boolean
			try {
				result =  _instanceRequirement.meet(SerializationUtil.newInstance(XML(object)));
			} catch(error : ReferenceError) {
				result = false;
			} catch(error : TypeError) {
				result = false;
			}
			return result;
		}
		
	}
}