package org.goverla.localization
{
	import org.goverla.interfaces.IConverter;

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