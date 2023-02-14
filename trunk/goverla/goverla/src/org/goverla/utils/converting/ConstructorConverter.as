package org.goverla.utils.converting
{
	import org.goverla.interfaces.IConverter;

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