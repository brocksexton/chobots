package org.goverla.utils {

    import mx.formatters.DateFormatter;
    import mx.utils.StringUtil;
    
    import org.goverla.constants.BrowserConstants;

    public class TextFormatter {
    	
    	public static const SHORT_DATE_FORMAT_STRING : String = "MMM. D, YYYY";
    	
    	public static const LONG_DATE_FORMAT_STRING : String = "MMMM D, YYYY";

		public static const CR_OR_LF_REG_EXP : RegExp = /[\r\n\u2028\u2029]+/g;

		public static const CRLF_REG_EXP : RegExp = /(\r\n)|(\n\r)/g;

		public static const CRLF_AND_WHITE_AROUND_REG_EXP : RegExp = /[ \t]*[\r\n\u2028\u2029]+[ \t]*/g;

		public static const WHITE_REG_EXP : RegExp = /[ \t\r\n\u2028\u2029]+/g;
		
		public static const PRE_URL_REG_EXP : RegExp = /[^a-z0-9]?(www\.[a-z0-9])/ig;
		
		public static const URL_REG_EXP : RegExp = new RegExp("https?://([a-z0-9\-\.\?/_=&]+)", "ig");

		public static const CRLF_CHARS : String = "\r\n\u2028\u2029\f";

    	public static const NON_LETTER_CHARS : String = CRLF_CHARS + " \t\b\\,.:;'/+-=_{([";

    	protected static const PLURAL_NOUN_TEMPLATE : String = "{0} {1}";
		
		private static const DIGIT_MASK : String = "#";
		
		private static const ANY_MASK : String = "A";
		
		private static const UPPERCASE_MASK : String = "C";
		
		private static const LOWERCASE_MASK : String = "c";
		
		private static const MASK_CHARS : String = DIGIT_MASK +
			ANY_MASK +
			UPPERCASE_MASK +
			LOWERCASE_MASK;
		
		private static const DIGIT_CHARS : String = "0123456789";

    	/**
    	 * @return string, trimmed to "length" and postfixed by Ellipsis if original string length was longer than desired
    	 */
        public static function getTrimmedTextWithEllipsis(text : String, length : int, trimPrecise : Boolean = true) : String {
            if ( text == null || length <=0 || text.length <= length) {
                return text;
            } else {
                var i : int = length;
				if (trimPrecise) {
					i--;
				} else {
					while (i > 0 && NON_LETTER_CHARS.indexOf(text.charAt(i)) < 0) {
						i--;
					}
				}
                while (i > 0 && NON_LETTER_CHARS.indexOf(text.charAt(i)) >= 0) {
                    i--;
                }
                return text.substring(0, i + 1) + "…";
            }
        }
        
    	/**
    	 * @return string, with every cr/lf symbol and serie of cr/lfs replaced with single space
    	 */
        public static function getTextWithoutCRLF(text : String, replacePattern : String = " ") : String {
			return text ? text.replace(CR_OR_LF_REG_EXP, replacePattern) : null;
        }

    	/**
    	 * @return string, with every cr/lf symbol and serie of cr/lfs replaced with single cr
    	 */
        public static function compressCRLF(text : String, replacePattern : String = "\r") : String {
			return text ? text.replace(CRLF_REG_EXP, replacePattern) : null;
        }

    	/**
    	 * @return string, with every group of white space symbols replaced with single space
    	 */
        public static function compressWhiteSpaces(text : String, replacePattern : String = " ") : String {
			return text ? text.replace(WHITE_REG_EXP, replacePattern) : null;
        }
    	
    	/**
    	 * @return string values, separated by any character or string (e. g. comma, dash, space). 
    	 */
        public static function getFormattedSeparatedValues(separator : String, ...values) : String {
        	var result : String = "";
        	for (var i : int = 0; i < values.length; i++) {
        		var value : String = values[i];
        		if (!Strings.isBlank(value)) {
        			result += (result != "" ? separator : "") + value;
        		}
        	}
        	return result;
        }

        /**
        * Format plural noun via numeric value, singularForm and pluralForm.
        * Examples:
        * 	var result : String = getFormattedPluralNoun(0, "entry", "entries"); // returns "No entries" 
        * 	var result : String = getFormattedPluralNoun(1, "message", "messages"); // returns "1 message" 
        * 	var result : String = getFormattedPluralNoun(2, "network", "networks"); // returns "2 networks" 
        */
        public static function getFormattedPluralNoun(value : int, singularForm : String, pluralForm : String, replaceZeroWithNo : Boolean = true, noForm : String = "No") : String {
        	var relevantCount : String = (value == 0 && replaceZeroWithNo ? noForm : value.toString());
        	var relevantForm : String = getRelevantForm(value, singularForm, pluralForm);
        	var result : String = StringUtil.substitute(PLURAL_NOUN_TEMPLATE, relevantCount, relevantForm);
        	return result;
        }
        
        public static function getRelevantForm(value : int, singularForm : String, pluralForm : String) : String {
        	return (Math.abs(value) == 1 ? singularForm : pluralForm);
        }
        
        /**
        * @return href html tag by url and optionally target, name, color, underline.
        */
        public static function getHrefTag(url : String, target : String = "_self", name : String = null, color : uint = 0x0000FF, underline : Boolean = true) : String {
			if (Strings.isBlank(name)) {
				name = url;
			}
			if (underline) {
				name = StringUtil.substitute("<u>{0}</u>", name);
			}
        	var result : String = StringUtil.substitute(
        			"<a href='{0}' target='{1}'><font color='{2}'>{3}</font></a>",
        			url, target, ("#" + color.toString(16)), name);
        	return result;
        }
        
		public static function getClickableText(text : String, eventText : String = "click", color : uint = 0x0000FF, underline : Boolean = true) : String {
			if (underline) {
				text = StringUtil.substitute("<u>{0}</u>", text);
			}
			var result : String = (Strings.isBlank(text) ? "" :
				StringUtil.substitute(
					"<a href='event:{0}'><font color='{1}'>{2}</font></a>",
					eventText, ("#" + color.toString(16)), text)
				);
			return result; 
		}

		public static function getHighlightedText(text : String, highlightedText : String, color : uint = 0x13883d) : String {
           	var result : String = text;
			if (!Strings.isBlank(highlightedText)) {
				var pattern : RegExp = new RegExp(highlightedText, "gi");
				var replacement : String = StringUtil.substitute("<font color='{0}'>$&</font>", "#" + color.toString(16));
				result = result.replace(pattern, replacement);
			}
			return result;
		}
        
		public static function getFormattedDate(date : Date, formatString : String) : String {
        	var dateFormatter : DateFormatter = new DateFormatter();
        	dateFormatter.formatString = formatString;
        	var result : String = dateFormatter.format(date);
            return result;
        }
        
		public static function getFormattedDateAndDaysAgo(date : Date, agoMillis : Number, formatString : String = LONG_DATE_FORMAT_STRING, separator : String = "<br />") : String {
		    var daysAgo : Number = Math.floor( agoMillis / (24*60*60*1000));
		    var result : String = 
		            getFormattedDate(date, formatString) + separator +
        		    getFormattedPluralNoun(daysAgo, "Day", "Days", false) + " Ago";
            return result;
        }

        public static function getFormattedProfitability(forProfit : Boolean) : String {
        	return (forProfit ? "" : "Charitable");
        }

        public static function getFormattedNetworkInfo(membersQuantity : Number, forProfit : Boolean, creationDate : Date) : String {
        	var membersQuantityDefined : Boolean = !isNaN(membersQuantity);
        	var creationDateDefined : Boolean = (creationDate != null);
        	var membersMessage : String = membersQuantityDefined ?
        		getFormattedPluralNoun(membersQuantity, "member", "members") : "";
            var profitabilityMessage : String = forProfit ? getFormattedProfitability(forProfit) : null;
            var creationDateMessage : String = creationDateDefined ?
            	"Created " + getFormattedDate(creationDate, SHORT_DATE_FORMAT_STRING) : "";
            return getFormattedSeparatedValues("<br />", membersMessage, profitabilityMessage, creationDateMessage);
        }
        
        public static function getFormattedPersonName(screenName : String, firstName : String, lastName : String) : String {
        	var screenNameDefined : Boolean = !Strings.isBlank(screenName);
        	var firstNameDefined : Boolean = !Strings.isBlank(firstName);
        	var lastNameDefined : Boolean = !Strings.isBlank(lastName);
        	return (firstNameDefined || lastNameDefined) ?
				//getFormattedSeparatedValues("<br />", firstName, lastName) : 
				getFormattedSeparatedValues(" ", firstName, lastName) : 
        		(screenNameDefined ? screenName : "No Name");
        }

        public static function getFormattedLongPersonName(firstName : String, lastName : String) : String {
        	return getFormattedSeparatedValues(" ", firstName, lastName);
        }
        
        public static function getFormattedCityAndState(city : String, state : String) : String {
			return getFormattedSeparatedValues(", ", city, state); 
        }
        
        public static function getFormattedAge(age : Number) : String {
        	var result : String = ((!isNaN(age) && age >= 0) ?
        		getFormattedPluralNoun(age, "year old", "years old", false) : "");
            return result;
        }
        
		public static function completeZero(value : Object, digitsCount : int = 2) : String {
			var number : String = value.toString();
			var zeroPrefixCount : int = digitsCount - number.length;
			var prefix : String = "";
			
			if (zeroPrefixCount > 0) {
				while (prefix.length < zeroPrefixCount) { 
					prefix += "0"; 
				}
			}
			
			return prefix + number;
		}
		
		public static function getUrlFormattedLabel(label : String) : String {
			return label.replace(/ /g, "").toLowerCase();
		}
		
		public static function getMaskedText(input : String, mask : String, blankChar : String = "_") : String {
			if (mask == null) {
				return null;
			}
			
			_blankChar = blankChar;
			
			var cache : Array = initCache(mask);
			paste(mask, input, 0, cache);
			
			return renderCache(mask, cache);
		}
		
		protected static function paste(inputMask : String, input : String, position : int, cache : Array) : int {
			var i : int = position;
			var j : int = 0;

			if (input != null) {
				do {
					var success : Boolean = false;
					while (!isMask(inputMask.charAt(i)) && i < inputMask.length - 1) {
						i++;
					}
					if (j < input.length) {
						var char : String = input.charAt(j++);
						var maskChar : String = inputMask.charAt(i);
						switch (maskChar) {
							case DIGIT_MASK :
								if (isDigit(char)) {
									cache[i] = char;
									i++;
									success = true;
								}
								break;
							case UPPERCASE_MASK :
								if (!isDigit(char)) {
									cache[i] = char.toUpperCase();
									i++;
									success = true;
								}
								break;
							case LOWERCASE_MASK :
								if (!isDigit(char)) {
									cache[i] = char.toLowerCase();
									i++;
									success = true;
								}
								break;
							case ANY_MASK :
								cache[i] = char;
								i++;
								success = true;
								break;
							default :
						}
					}
				} while(success);			
			}

			return i;
		}
		
		private static function initCache(inputMask : String) : Array {
			return (inputMask.split("").map(clearAll));
		}
		
		private static function renderCache(inputMask : String, cache : Array) : String {
			var i : int = cache.length;
			do {
				i--;
			} while (!(isMask(inputMask.charAt(i)) && cache[i] != _blankChar) && i >= 0);
			var result : String = cache.slice(0, i + 1).join("");
			return result;
		}
		
		private static function isDigit(char : String) : Boolean {
			return (isChar(char) == 1 && DIGIT_CHARS.indexOf(char) != -1);
		}
		
		private static function isMask(char : String) : Boolean {
			return (isChar(char) && MASK_CHARS.indexOf(char) != -1);
		}
		
		private static function isChar(char : String) : Boolean {
			return (char.length == 1);
		}
		
		private static function clearAll(element : String, index : int, array : Array)  : String {
			return (isMask(element) ? _blankChar : element);
		}

		private static var _blankChar : String;
		
	}

}