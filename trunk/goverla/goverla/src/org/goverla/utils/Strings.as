package org.goverla.utils {
	
	import org.goverla.errors.IllegalArgumentError;
	
	
	/**
	 * @author Maxym Hryniv
	 */
	public class Strings {
	
		private static const KB_SIZE : Number = 1024;

		public static const DELIMITER : String = " `~!@#$%^&*()-_=+[]{};:\'\",<.>/?\\|";
		public static const WHITESPACE : String = " \t\r\n\f";
		private static const ID_CHARS : String = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_";
		protected static const RETURN_EXPRESSION : RegExp = /\r\n/gm;
		
		protected static const SPACE_EXPRESSION : RegExp = /[ ]/g;
		
		public static function generateRandomId(length : uint = 10) : String {
			var result : String = "";
			for(var i : uint = 0; i < length; i++) {
				var index : uint = uint(Math.random() * ID_CHARS.length);
				result += ID_CHARS.charAt(index);
			}
			return result;
		} 
		
		public static function addRandomParameter(url : String) : String {
			return substitute("{0}?{1}", url, generateRandomId());
		}		
		
		public static function substitute(format : String, ...args) : String 
		{
			var result : String = format;
			for(var i : int = 0; i < args.length; i++)
				result = result.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
			return result;
		}

	    public static function trimSymbols(str:String, symbols : String):String
	    {
	        if (str == null) return '';
	        
	        var startIndex:int = 0;
	        while (contains(symbols, str.charAt(startIndex)))
	            startIndex++;
	
	        var endIndex:int = str.length - 1;
	        while (contains(symbols, str.charAt(endIndex)))
	            endIndex--;
	
	        if (endIndex >= startIndex)
	            return str.slice(startIndex, endIndex + 1);
	        else
	            return "";
	    }

	    public static function trim(str:String):String
	    {
	    	return trimSymbols(str, WHITESPACE);
	    }

		public static function getFileSizeText(size : Number, precision : uint) : String 
		{
			var index : Number = 0;
			var metrics : Array = ["", "K", "M", "G"];
			while(size > KB_SIZE && metrics.length > index + 1)
			{
				size /= KB_SIZE;
				index++;
			}
			return size.toFixed(precision) + metrics[index];
		}

		public static function escapeSpecialCharacters(source : String) : String {
			return replaceCharacters(source, ["<", ">", "\"", "\'", "&"], ["&lt;", "&gt;", "&quot;", "&apos;", "&amp;"]);
		}
		
		public static function replaceCharacters(source : String, characters : Array, matches : Array) : String {
			var result : String = "";
			for (var i : int = 0; i < source.length; i++) {
				var matchIndex : int = characters.indexOf(source.charAt(i));
				if (matchIndex != -1) {
					result += matches[matchIndex];
				} else {
					result += source.charAt(i);
				}
			}
			return result;
		}
		
		public static function replacePatterns(source : String, patterns : Array, matches : Array) : String {
			var result : String = source;
			for (var i : int = 0; i < patterns.length; i++) {
				result = result.replace(patterns[i], matches[i]);
			}
			return result;
		}
	
		public static function reverse(source : String) : String {
			var result : String = "";
			for(var index : Number = source.length - 1 ; index >= 0 ; index-- ) {
				result += source[index]; 
			}
			return result;
		}
	
		public static function startsWidth(source : String, sought : String) : Boolean {
			return source.length >= sought.length && source.indexOf(sought) == 0;
		}
		
		public static function contains(source : String, sought : String) : Boolean {
			return (source.indexOf(sought) != -1);
		}
		
		public static function removeWhiteSpaces(source : String) : String {
			return source.split(" ").join("");
		}
		
		public static function removeReturns(source : String) : String {
			return (source != null ? source.replace(RETURN_EXPRESSION, "\n") : null);
		}
	
		public static function removeSymbols(source : String, symbols : String) : String {
			var result : String = source;
			for(var i : Number = 0; i < symbols.length; i++) {
				result = result.split(symbols.charAt(i)).join("");
			}
			return result;
		}
		
		public static function isBlank(source : String) : Boolean {
			return (source == null || source.length == 0);
		}
	
		public static function insertStringAt(sourse : String, subString : String, index : Number) : String {
			var startString : String = sourse.substring(0, index);
			var endString : String = sourse.substring(index, sourse.length);
			return (startString + subString + endString);	
		}
	
		public static function removeStringAt(source : String, startIndex : Number, endIndex : Number) : String {
			if(startIndex > endIndex) {
				throw new IllegalArgumentError("endIndex must be greater than startIndex");
			}
			var startString : String = source.substring(0, startIndex);
			var endString : String = source.substr(endIndex, source.length);
			return (startString + endString);
		}
		
		public static function removeDuplications(source : String, substring : String) : String {
			var firstIndex : int = source.indexOf(substring);
			var lastIndex : int = source.lastIndexOf(substring);
			while(firstIndex != lastIndex) {
				source = removeStringAt(source, lastIndex, lastIndex + substring.length);
				firstIndex = source.indexOf(substring);
				lastIndex = source.lastIndexOf(substring);
			}
			return source;
		}
	
		public static function isDelimiter(character : String) : Boolean {
			var result : Boolean = false;
			if (character.length == 1) {
				result = contains(DELIMITER, character);
			} else {
				throw new Error("You can input only one character");
			}
			return result ;
		}
	
	}

}