package com.kavalok.utils
{
	public class TimeUtils
	{
		public static function getTimeString(miliseconds : Number) : String
		{
			var hours : Number = int(miliseconds / 3600000);
			miliseconds -= hours * 3600000;
			var minutes : Number = int(miliseconds / 60000);
			miliseconds -= minutes * 60000;
			var seconds : Number = int(miliseconds / 1000);
			var result : String = 
				hours == 0 
				?
				Strings.substitute("{1}:{2}", hours, getTimeSubstring(minutes), getTimeSubstring(seconds))
				: Strings.substitute("{0}:{1}:{2}", hours, getTimeSubstring(minutes), getTimeSubstring(seconds));
			var match : Array = result.match(/0\d.*/);
			if(match != null && match[0] == result)
			{
				result = result.substr(1, result.length - 1);
			}
			return result;				
		}

		public static function getTimeSubstring(value : uint) : String
		{
			var result : String = String(value);
			if(result.length == 1)
			{
				result = "0" + result;
			}
			return result;
		}
	}
}