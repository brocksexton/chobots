package com.kavalok.errors
{
	import com.kavalok.utils.Strings;
	
	public class AbstractMethodError extends Error
	{
		public function AbstractMethodError(clazz : Class, methodName : String)
		{
			super(Strings.substitute("{0}.{1}() is abstract method"));
		}
		
	}
}