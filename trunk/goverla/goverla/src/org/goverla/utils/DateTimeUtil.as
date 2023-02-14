package org.goverla.utils {
	
	public class DateTimeUtil {
		
		public static const DAY_SHORT : Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

		public static const DAY_FULL : Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

		public static const MONTH_SHORT : Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

		public static const MONTH_FULL : Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		
	    public static const MILLISECONDS_IN_MINUTE : Number = 1000 * 60;
	    
	    public static const MILLISECONDS_IN_HOUR : Number = 1000 * 60 * 60;
	    
	    public static const MILLISECONDS_IN_DAY : Number = 1000 * 60 * 60 * 24;
	    
	    public static const MILLISECONDS_IN_WEEK : Number = 1000 * 60 * 60 * 24 * 7;
	    
	    public static const MILLISECONDS_IN_MONTH : Number = 1000 * 60 * 60 * 24 * 30;
	    
	    public static const MILLISECONDS_IN_YEAR : Number = 1000 * 60 * 60 * 24 * 365;
	    
		public static const MILLISECONDS : String = "milliseconds";
		
		public static const SECONDS : String = "seconds";
		
		public static const MINUTES : String = "minutes";
		
		public static const HOURS : String = "hours";
		
		public static const DAYS : String = "days";
		
		public static const WEEKS : String = "weeks";
		
		public static const MONTHS : String = "months";
		
		public static const YEARS : String = "years";
		
		public static function getNextStepDate(date : Date, multiplier : int, format : String) : Date {
			var result : Date = new Date();
			
			if (format.indexOf("S") >= 0) {
				result.setTime(date.getTime() + multiplier);
			} else if (format.indexOf("s") >= 0) {
				result.setTime(date.getTime() + multiplier * 1000);
			} else if (format.indexOf("m") >= 0) {
				result.setTime(date.getTime() + multiplier * MILLISECONDS_IN_MINUTE);
			} else if ((format.indexOf("H") >= 0) || (format.indexOf("h") >= 0) ||
				(format.indexOf("K") >= 0) || (format.indexOf("k") >= 0)) {
				result.setTime(date.getTime() + multiplier * MILLISECONDS_IN_HOUR);
			} else if ((format.indexOf("D") >= 0) || (format.indexOf("d") >= 0)) {
				result.setTime(date.getTime() + multiplier * MILLISECONDS_IN_DAY);
			} else if ((format.indexOf("W") >= 0) || (format.indexOf("w") >= 0)) {
				result.setTime(date.getTime() + multiplier * MILLISECONDS_IN_WEEK);
			} else if (format.indexOf("M") >= 0) {
				result.setTime(date.getTime() + multiplier * MILLISECONDS_IN_MONTH);
			} else if ((format.indexOf("Y") >= 0) || (format.indexOf("y") >= 0)) {
				result.setTime(date.getTime() + multiplier * MILLISECONDS_IN_YEAR);
			} else {
				result = date;
			}
			
			return result;
		}
		
		public static function getLabelUnits(format : String) : String {
			if ((format.indexOf("Y") >= 0) || (format.indexOf("y") >= 0)) {
				return null;
			} else if (format.indexOf("M") >= 0) {
				return null;
			} else if ((format.indexOf("W") >= 0) || (format.indexOf("w") >= 0)) {
				return MONTHS;
			} else if ((format.indexOf("D") >= 0) || (format.indexOf("d") >= 0)) {
				return DAYS;
			} else if ((format.indexOf("H") >= 0) || (format.indexOf("h") >= 0) ||
					(format.indexOf("K") >= 0) || (format.indexOf("k") >= 0)) {
				return HOURS;
			} else if (format.indexOf("m") >= 0) {
				return MINUTES;
			} else if (format.indexOf("s") >= 0) {
				return SECONDS;
			} else if (format.indexOf("S") >= 0) {
				return MILLISECONDS;
			} else {
				return null;
			}
		}
		
		/*
		* Imported from Flash Tangraph Code
		* Returns date (string) using java.text.JavaSimpleDateFormat (format)
		* Days and months' names depends on language - "ru" or "en" (default
		* Unsupported features (in compare with JavaSimpleDateFormat):
		*   w  Week in year  Number  27
		*   W  Week in month  Number  2
		* Extensions:
		* A (AM/PM with big chars), U (unix time), L (leap year flag)
		*/
		public static function toString(date : Date, format : String) : String {
			var formatd : Array = new Array();
			var stmp : String = "";
			var itmp : int = 0;
			var sout : String = "";

			// Split format string by groups			
			for (var i : int = 0; i < format.length; i++) {
				stmp += format.charAt(i);
				if (format.charAt(i) != format.charAt(i+1)) {
					formatd.push(stmp);
					stmp = "";
				}
			}
			
			// Analyze each group
			for (i = 0; i < formatd.length; i++) {
				// pass non-format chars directly to output string
				if (!isCharLatinAt(formatd[i] as String, 0)) {
					sout += (formatd[i] as String);
				} else {
					switch((formatd[i] as String).charAt(0)) {
						// G  Era designator  Text  AD
						case 'G' :
							sout += "AD"; // ?
							break;
				
						// y  Year  Year  1996; 96
						case 'y' :
							if ((formatd[i] as String).length >= 4)
								// full form
								sout += leadingZero(date.getFullYear().toString(), (formatd[i] as String).length);
							else
								// short form
								sout += date.getFullYear().toString().substr(date.getFullYear().toString().length - 2, 2);
							break;
				
						// L  Leap Year flag (0,1)
						case 'L' :
							sout += isLeapYear(date) ? 1 : 0;
							break;
				
						// M  Month in year  Month  July; Jul; 07
						case 'M' :
							// 1 or 2 digits
			                if (formatd[i].length <= 2) 
			                	sout += leadingZero((date.getMonth() + 1).toString(), formatd[i].length);
							if (formatd[i].length == 3) 
								sout += MONTH_SHORT[date.getMonth()]; 
							if (formatd[i].length > 3) 
								sout += MONTH_FULL[date.getMonth()];
							break;
				
						// w  Week in year  Number  27
						case 'w' : break;
				
						// W  Week in month  Number  2
						case 'W' : break;
				
						// D  Day in year  Number  189
						case 'D' :
							var dy : Number = date.getFullYear();
							var dd : Date = new Date(date.getTime());
							itmp = -1;
							while (dd.getFullYear() == dy) {
								dd.setDate(dd.getDate() - 1);
								itmp++;
							}
							sout += leadingZero(itmp.toString(), formatd[i].length);
							break;
				
						// d  Day in month  Number  10
						case 'd' :
							itmp = date.getDate();
							sout += leadingZero(itmp.toString(), formatd[i].length);
							break;
				
						// F  Day of week in month  Number  2
						case 'F' :
							itmp = date.getDay();
							sout += leadingZero(itmp.toString(), formatd[i].length);
							break;
				
						// E  Day in week  Text  Tuesday; Tue
						case 'E' :
							if (formatd[i].length > 3) 
								sout += DAY_FULL[date.getDay()];
							else 
								sout += DAY_SHORT[date.getDay()]; 
							break;
				
						// a  Am/pm marker  Text  pm
						case 'a' :
							sout += (date.getHours() < 12) ? "am" : "pm";
							break;
				
						// A  Am/pm marker  Text  PM <- my extension to the JavaSimpleDateDataFormat
						case 'A' :
							sout += (date.getHours() < 12) ? "AM" : "PM";
							break;
				
						// H  Hour in day (0-23)  Number  0
						case 'H' :
							itmp = date.getHours();
							stmp = leadingZero(itmp.toString(), formatd[i].length);
							sout += stmp;
							break;
				
						// k  Hour in day (1-24)  Number  24
						case 'k' :
							itmp = (date.getHours() == 0) ? 24 : date.getHours();
							sout += leadingZero(itmp.toString(), formatd[i].length);
							break;
				
						// K  Hour in am/pm (0-11)  Number  0
						case 'K' :
							itmp = date.getHours() % 12;
							sout += leadingZero(itmp.toString(), formatd[i].length);
							break;
				
						// h  Hour in am/pm (1-12)  Number  12
						case 'h' :
							itmp = (date.getHours() % 12 == 0)  ? 12 : date.getHours() % 12;
							sout += leadingZero(itmp.toString(), formatd[i].length);
							break;
				
						// m  Minute in hour  Number  30
						case 'm' :
							itmp = date.getMinutes();
							sout += leadingZero(itmp.toString(), formatd[i].length);
							break;
				
						// s  Second in minute  Number  55
						case 's' :
							itmp = date.getSeconds();
							sout += leadingZero(itmp.toString(), formatd[i].length);
							break;
				
						// S  Millisecond  Number  978
						case 'S' :
							itmp = date.getMilliseconds();
							sout += leadingZero(itmp.toString(), formatd[i].length);
							break;
				
						// U  seconds since the Unix Epoch (January 1 1970 00:00:00 GMT) <- my extension 
						// to the JavaSimpleDateDataFormat
						case 'U' :
							sout += date.getTime();
							break;
				
						// z  Time zone  General time zone  Pacific Standard Time; PST; GMT-08:00
						case 'z' :
							var off : Number = date.getTimezoneOffset();
							//in Flash, offsets are positive west of GMT
							var pos : Boolean = off <= 0;
							var mins : String = (Math.abs(off % 60)).toString();
							if (mins.length == 1) 
								mins = "0" + mins;
								
							var hours : String = Math.floor(Math.abs(off / 60)).toString();
							if (hours.length == 1) 
								hours = "0" + hours;
							
							sout += "GMT" + (pos ? "+" : "-") + hours + ":" + mins;
							break;
				
						// Z  Time zone  RFC 822 time zone  -0800
						case 'Z' :
							sout += date.getTimezoneOffset() * (-60);
							break;
					}
				}
			}
			
			return sout;
		}
		
		public static function parse(date : String, format : String) : Date {
			var formatd : Array = new Array();
			var stmp : String;
			var len : int;
			var ix : int;
			var pObj : Object = new Object();
			
			// Split format string into groups
			stmp = "";
			for (var i : int = 0; i < format.length; i++) {			
				stmp += format.charAt(i);
				if (format.charAt(i) != format.charAt(i + 1)) {
					formatd.push(stmp);
					stmp = "";
				}
			}
			
			var curpos : int = 0;
			
			// Analyze each format group 
			for(i = 0; i < formatd.length; i++) {
				switch (formatd[i].charAt(0)) {
					// y  Year  Year  1996; 96
					case 'y' :
						ix = indexOfChange(date, isCharDigitAt, curpos, false);
						len = ix - curpos;
						pObj.yL = date.substring(curpos, ix);
						
						// expand 1-2 digits year (-80, +20 years)
						if (formatd[i].length <= 2) {
							var curDate : Date = new Date();
							if ((curDate.getFullYear() - Number("19" + leadingZero(pObj.yL, 2))) > 80)
								pObj.yL = Number("20" + leadingZero(pObj.yL, 2));
							else
								pObj.yL = Number("19" + leadingZero(pObj.yL, 2))
						}
						else 
							pObj.yL = Number(pObj.yL);
						
						curpos += len;
						break;
			
					// M  Month in year  Month  July; Jul; 07
					case 'M' :
						// month parsed as a number
						if (formatd[i].length < 3) {
							ix = indexOfChange(date, isCharDigitAt, curpos, false);
							len = ix - curpos;
							pObj.mU = Number(date.substring(curpos, ix));
							curpos += len;
						} else {
							// month parsed as a string (Jul, July)
							var monthName : String;
							
							for (var e : int = 0; e < MONTH_FULL.length; e++) {
								if (MONTH_FULL[e].toLowerCase() == date.substr(curpos, MONTH_FULL[e].length).toLowerCase()) {
									monthName = MONTH_FULL[e];
									break;
								}
							}
			
							// if not found in monthF..
							if (monthName == null) {
								for (e = 0; e < MONTH_SHORT.length; e++) {
									if (MONTH_SHORT[e].toLowerCase() == date.substr(curpos, MONTH_SHORT[e].length).toLowerCase()) {
										monthName = MONTH_SHORT[e];
										break;
									}
								}
							}
							
							pObj.mU = e + 1;
				       		curpos += monthName.length;
						}
						break;
			
					// d  Day in month  Number  10
					case 'd' :
						ix = indexOfChange(date, isCharDigitAt, curpos, false);
						len = ix - curpos;
						pObj.dL = Number(date.substring(curpos, ix));
						curpos += len;
						break;
			
					// a  Am/pm marker  Text  pm
					case 'a' :
						ix = indexOfChange(date, isCharLatinAt, curpos, false);
						len = ix - curpos;
						pObj.a = date.substring(curpos, ix).toLowerCase();
						curpos += len;
						break;
			
					// A  Am/pm marker  Text  PM
					case 'A' :
						ix = indexOfChange(date, isCharLatinAt, curpos, false);
						len = ix - curpos;
						pObj.a = date.substring(curpos, ix).toLowerCase();
						curpos += len;
						break;
			
					// H  Hour in day (0-23)  Number  0
					case 'H' :
						ix = indexOfChange(date, isCharDigitAt, curpos, false);
						len = ix - curpos;
						pObj.hU = Number(date.substring(curpos, ix));
						curpos += len;
						break;
			
					// k  Hour in day (1-24)  Number  24
					case 'k' :
						ix = indexOfChange(date, isCharDigitAt, curpos, false);
						len = ix - curpos;
						pObj.kL = Number(date.substring(curpos, ix));
						curpos += len;
						break;
			
					// K  Hour in am/pm (0-11)  Number  0
					case 'K' :
						ix = indexOfChange(date, isCharDigitAt, curpos, false);
						len = ix - curpos;
						pObj.kU = Number(date.substring(curpos, ix));
						curpos += len;
						break;
			
					// h  Hour in am/pm (1-12)  Number  12
					case 'h' :
						ix = indexOfChange(date, isCharDigitAt, curpos, false);
						len = ix - curpos;
						pObj.hL = Number(date.substring(curpos, ix));
						curpos += len;
						break;
			
					// m  Minute in hour  Number  30
					case 'm' :
						ix = indexOfChange(date, isCharDigitAt, curpos, false);
						len = ix - curpos;
						pObj.mL = Number(date.substring(curpos, ix));
						curpos += len;
						break;
			
					// s  Second in minute  Number  55
					case 's' :
						ix = indexOfChange(date, isCharDigitAt, curpos, false);
						len = ix - curpos;
						pObj.sL = Number(date.substring(curpos,ix));
						curpos+=len;
						break;
			
					// S  Millisecond  Number  978
					case 'S' :
						ix = indexOfChange(date, isCharDigitAt, curpos, false);
						len = ix - curpos;
						pObj.sU = Number(date.substring(curpos, ix));
						curpos += len;
						break;
			
					// U  seconds since the Unix Epoch (January 1 1970 00:00:00 GMT) <- my extension 
					// to the JavaSimpleDateDataFormat
					case 'U' :
						ix = indexOfChange(date, isCharDigitAt, curpos, false);
						len = ix - curpos;
						pObj.uU = Number(date.substring(curpos, ix));
						curpos += len;
						break;
			
					// z  Time zone  General time zone  Pacific Standard Time; PST; GMT-08:00
					case 'z' :
						break;
			
					// Z  Time zone  RFC 822 time zone  -0800
					case 'Z' :
						break;
					
					default :
						curpos += formatd[i].length; //skip non-format chars
						break;
				}
			}
			

			// K  Hour in am/pm (0-11)  
			// h  Hour in am/pm (1-12)  
			// if 24h time not defined (only am/pm)
	        if (pObj.hU == null) {
				// if 0..11 hours time defined, convert it to 1..12
	        	if (pObj.kU != null)
					if (pObj.kU == 0) 
						pObj.hL = 12;
	
				// if 1..12 hours time defined
	        	if (pObj.hL != null) {		                        
		        	if (pObj.a == "am") { 
		        		pObj.hU = pObj.hL; 
		        	}
	        	
					if (pObj.a == "pm") {
						pObj.hU = pObj.hL + 12;
						if (pObj.hU == 24) 
							pObj.hU = 0;
					}
	        	}
			}
		
			var rDate : Date = new Date();
		
			// if time defined in unix format, convert it
			if (pObj.uU != null) {
				rDate.setTime(pObj.uU);
				return rDate;
			} else {
				if (pObj.yL == null) 
					pObj.yL = 1970;
				if (pObj.mU == null) 
					pObj.mU = 1;
				if (pObj.dL == null) 
					pObj.dL = 1;
				if (pObj.hU == null) 
					pObj.hU = 0;
				if (pObj.mL == null) 
					pObj.mL = 0;
				if (pObj.sL == null) 
					pObj.sL = 0;
				if (pObj.sU == null) 
					pObj.sU = 0;
		
				return new Date(pObj.yL, (pObj.mU - 1), pObj.dL, pObj.hU, pObj.mL, pObj.sL, pObj.sU);
			}
		}
		
		public static function isLeapYear(date : Date) : Boolean {
			var y : Number = date.getFullYear();
			return (y % 4 ==0) && !((y % 100 == 0) && (y % 400 != 0));
		}
		
		public static function indexOfChange(str : String, func : Function, startIndex : int, flag : Boolean) : int {
			if (flag)
				for (var i : int = startIndex; i < str.length; i++) {
					if (func(str, i) as Boolean) return i;
				}
			else
				for (i = startIndex; i < str.length; i++) {
					if (!(func(str, i) as Boolean)) return i;
				}
			
			return str.length;
		}
		
		public static function isCharDigitAt(str : String, index : int) : Boolean {
			if ((str.charCodeAt(index) >= 48) && (str.charCodeAt(index) <= 57)) 
				return true; 
			else 
				return false;
		}
		
		public static function isCharLatinAt(str : String, index : int) : Boolean {
			if ((str.charCodeAt(index) >= 65 &&
					str.charCodeAt(index) <= 90) ||
				(str.charCodeAt(index) >= 97 &&
					str.charCodeAt(index) <= 122)) 
				return true; 
			else 
				return false;
		}
		
		public static function leadingZero(str : String, num : Number) : String {
			var raw : String = "";
			for (var i : int = 0; i < (num - str.length); i++) 
				raw += "0";
			return raw + str;
		}
		
	}
	
}