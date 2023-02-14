package org.goverla.utils.comparing
{
	import org.goverla.interfaces.IRequirement;
	import org.goverla.utils.Objects;
	
	public class PropertyRequirement extends PropertyCompareRequirement
	{
		private var _req : IRequirement;
		
		public function PropertyRequirement(req : IRequirement, properyName:String)
		{
			super(properyName, null);
			_req = req;
		}
		
		override public function meet(object:Object):Boolean
		{
			return _req.meet(Objects.getProperty(object, propertyName));
		}
		
	}
}