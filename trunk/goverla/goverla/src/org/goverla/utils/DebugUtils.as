package org.goverla.utils {
	
	import mx.utils.StringUtil;
	
	public class DebugUtils {
		
		public static function traceDebug(text : String, ... rest) : void {
			traceText(StringUtil.substitute(text, rest), "DEBUG");
		}
		
		public static function traceInfo(text : String, ... rest) : void {
			traceText(StringUtil.substitute(text, rest), "INFO");
		}
		
		private static function traceText(text : String, textType : String) : void {
			var dateTime : Date = new Date();
			var pattern : String = "{0}.{1}.{2} {3}:{4}:{5}:{6} {7} {8}";
			trace(StringUtil.substitute(pattern,
				TextFormatter.completeZero(dateTime.date),
				TextFormatter.completeZero(dateTime.month), 
				dateTime.fullYear,
				TextFormatter.completeZero(dateTime.hours), 
				TextFormatter.completeZero(dateTime.minutes), 
				TextFormatter.completeZero(dateTime.getSeconds()), 
				TextFormatter.completeZero(dateTime.milliseconds, 3),
				textType,
				text));
		}
		
	}
	
}