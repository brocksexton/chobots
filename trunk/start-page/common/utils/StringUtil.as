package common.utils
{
	
	/**
	* ...
	* @author Canab
	*/
	public class StringUtil
	{
		static public const EMPTY_CHARS:String = ' \t\r\n\f' + String.fromCharCode(160);
		
		public static function replaceChars(source:String, characters:Array, matches:Array):String
		{
			var result:String = '';
			
			for (var i:int = 0; i < source.length; i++)
			{
				var matchIndex:int = characters.indexOf(source.charAt(i));
				
				if (matchIndex != -1)
					result += matches[matchIndex];
				else
					result += source.charAt(i);
			}
			
			return result;
		}
		
		static public function isBlankString(source:String):Boolean
		{
			for (var i:int = 0; i <= source.length; i++)
			{
				if (EMPTY_CHARS.indexOf(source.charAt(i)) < 0)
					return false;
			}
			
			return true;
		}
		
		
		public static function trim(str:String):String
		{
			if (str == null)
				return '';
			
			var index1:int = 0;
			var index2:int = str.length - 1;
			var length:int = str.length;
			
			while (index1 < length && EMPTY_CHARS.indexOf(str.charAt(index1)) >= 0)
			{
				index1++;
			}

			while (index2 > 0 && EMPTY_CHARS.indexOf(str.charAt(index2)) >= 0)
			{
				index2--;
			}
			

			return (index2 >= index1)
				? str.slice(index1, index2 + 1)
				: '';
		}
	
		public static function format(str:String, ... args):String
		{
			var len:int = args.length;
			
			for (var i:int = 0; i < args.length; i++)
			{
				str = str.replace(new RegExp('\\{' + i + '\\}', 'g'), args[i]);
			}

			return str;
		}
		
	}
	
}