package org.goverla.utils {

	/**
	 * Levenshtein.getDistance() static method detects the "difference" between two strings
	 * s1 and s2 using Levenshtein distance algorithm http://en.wikipedia.org/wiki/Levenshtein_distance
	 * 
	 * @author Vladimir Levenshtein http://en.wikipedia.org/wiki/Vladimir_Levenshtein
	 * @author Stanislav Zayarsky
	 * @author Sergey Kovalyov
	 */
	public class Levenshtein {
	
		public static function getDistance(s1 : String, s2 : String) : int {
			var matrix : Array = new Array();
			var cost : int;
			var i : int;
			var j : int;
	
			if (s1.length == 0 || s2.length == 0) {
				return Math.max(s1.length, s2.length);
			}
	
			for (i = 0; i < s1.length + 1; i++) {
				matrix[i] = new Array();
				matrix[i][0] = i;
			}
	
			for (i = 0; i < s2.length + 1; i++) {
				matrix[0][i] = i;
			}
	
			for (i = 0; i < s1.length; i++) {
				for (j = 0; j < s2.length; j++) {
					cost = (s1.charAt(i).toUpperCase() == s2.charAt(j).toUpperCase()) ? 0 : 1;
					matrix[i + 1][j + 1] = Math.min(matrix[i][j + 1] + 1, matrix[i + 1][j] + 1, matrix[i][j] + cost);
				}
			}
	
			return (matrix[s1.length][s2.length] as int);
		}
		
	}

}