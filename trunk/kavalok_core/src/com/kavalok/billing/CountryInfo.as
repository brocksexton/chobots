package com.kavalok.billing
{
	import com.kavalok.utils.ReflectUtil;
	
	
	public class CountryInfo
	{

		public var id:String;
		public var mame:String;
		public var hasprov:Boolean;
		
		public function CountryInfo(info:Object)
		{
			ReflectUtil.copyFieldsAndProperties(info, this);
			
		}
		
				
	}
}