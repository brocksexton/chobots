package com.kavalok.billing
{
	import com.kavalok.utils.ReflectUtil;

	public class ProviderInfo
	{
		
		public var id:String;
		public var name:String;

		public function ProviderInfo(info:Object)
		{
			ReflectUtil.copyFieldsAndProperties(info, this);
		}
		
		
	}
}