package org.goverla.utils.converting
{
	import org.goverla.interfaces.IConverter;

	public class FunctionConverter implements IConverter
	{
		private var _func : Function;
		
		public function FunctionConverter(func : Function)
		{
			_func = func;
		}

		public function convert(source:Object):Object
		{
			return _func(source);
		}
		
	}
}