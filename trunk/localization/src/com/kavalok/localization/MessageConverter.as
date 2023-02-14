package com.kavalok.localization
{
	import com.kavalok.interfaces.IConverter;

	public class MessageConverter implements IConverter
	{
		public function MessageConverter()
		{
		}

		public function convert(source:Object):Object
		{
			return String(source).replace(/\r\n/g, "\n");
		}
		
	}
}