package org.goverla.utils {

	import org.goverla.errors.IllegalArgumentError;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateBase;
	
	/**
	 * @author Maxym Hryniv
	 */
	public class Dates {
		
		public static const monthNamesLong : ArrayCollection = new ArrayCollection(DateBase.monthNamesLong);
		
		public static const monthNamesShort : ArrayCollection = new ArrayCollection(DateBase.monthNamesShort);
		
		public function Dates() {
		}
		
		public static function getFullMonthName(index : int) : String {
			return getMonthName(monthNamesLong, index);
		}
		
		public static function getShortMonthName(index : int) : String {
			return getMonthName(monthNamesShort, index);
		}
		
		public static function getMonthNumber(name : String) : int {
			var result : int = -1;
			if (monthNamesLong.contains(name)) {
				result = monthNamesLong.getItemIndex(name);
			} else if (monthNamesShort.contains(name)) {
				result = monthNamesShort.getItemIndex(name);
			} else {
				throw new IllegalArgumentError("Invalid month name: " + name);
			}
			
			return result;
		}
	
		public static function getMonthDayCount(month : int, year : int) : int {
			var result : int;
			switch(month) {
				case 0:
				case 2:
				case 4:
				case 6:
				case 7:
				case 9:
				case 11:
					result = 31;
					break;
				case 1:
					result = isLeapYear(year) ? 29 : 28;
					break;
				default:
					result = 30;
					break;
			}
			return result;
		}
		
		public static function isLeapYear(year : int) : Boolean {
			return ((year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0)));
		}
	
		public static function max(firstDate : Date, secondDate : Date) : Date {
			return (secondDate > firstDate ? secondDate : firstDate);
		}

		public static function min(firstDate : Date, secondDate : Date) : Date {
			return (secondDate > firstDate ? firstDate : secondDate);
		}
		
        public static function getAge(birthday : Date) : int {
            var today : Date = new Date();
            var result : int = today.fullYear - birthday.fullYear;
            if ((today.month < birthday.month) ||
                ((today.month == birthday.month) && (today.date < birthday.date)) ) {
                result--;
            }
            return result;
        }
        
        private static function getMonthName(months : ArrayCollection, index : int) : String {
			if ((index >= 0) && (index < 12)) {
				return String(months.getItemAt(index));
			} else {
				throw new IllegalArgumentError("Invalid month index: " + index);
			}
        }
        
	}

}