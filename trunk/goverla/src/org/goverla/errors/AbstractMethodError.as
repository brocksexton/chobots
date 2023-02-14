package org.goverla.errors
{
	import mx.utils.StringUtil;
	
	public class AbstractMethodError extends Error
	{
		public function AbstractMethodError(clazz : Class, methodName : String)
		{
			super(StringUtil.substitute("{0}.{1}() is abstract method"));
		}
		
	}
}