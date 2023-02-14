package com.kavalok.utils.converting
{
	import com.kavalok.interfaces.IConverter;

	public class ConstructorConverter implements IConverter
	{
		private var _constructor : Class;
		
		public function ConstructorConverter(constructor : Class)
		{
			_constructor = constructor;
		}

		public function convert(source:Object):Object
		{
			return new _constructor(source);
		}
		
	}
}