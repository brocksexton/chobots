package com.kavalok.utils
{
	import com.kavalok.utils.comparing.PropertyCompareRequirement;

	public class PrefixRequirement extends PropertyCompareRequirement
	{
		public function PrefixRequirement(properyName:String, prefix:String)
		{
			super(properyName, prefix);
		}
		
		override public function meet(object : Object) : Boolean {
			return Strings.startsWidth(String(Objects.getProperty(object, propertyName)), String(propertyValue));
		}
	}
}