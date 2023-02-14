package com.kavalok.remoting
{
	import com.kavalok.utils.ReflectUtil;
	
	public class DataObject
	{
		public function DataObject(data:Object)
		{
			ReflectUtil.copyFieldsAndProperties(data, this);
		}
	}
}