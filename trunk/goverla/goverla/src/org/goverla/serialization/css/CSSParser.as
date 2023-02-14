package org.goverla.serialization.css {
	
	
	import mx.utils.StringUtil;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.css.CSSDeclaration;
	import org.goverla.css.CSSStyle;
	import org.goverla.css.CSSStylesGroup;
	import org.goverla.interfaces.IIterator;
	import org.goverla.utils.Objects;
	import org.goverla.utils.Strings;
	
	/**
	 * @author Maxym Hryniv
	 */
	public class CSSParser {
	
		private static const GET_STYLE_NAME_AND_DECLARATIONS_PATTERN : RegExp = / *([\w-]+) *\{ *([\w-0-9 :;]*)/g;
	
		private static const GET_NAME_AND_VALUE : RegExp = / *([\w-]+) *: *([\w#,]+) */g;
	
		public static function parse(source : String) : CSSDeclaration {
			return getStyleGroups(source);
		}
		
		private static function getStyleGroups(source : String) : CSSDeclaration {
			var result : CSSDeclaration = new CSSDeclaration();
			var allStrings : Array = source.split("}");
			var groupStrings : ArrayList = new ArrayList(allStrings.slice(0, allStrings.length-1));
			for(var iterator : IIterator = groupStrings.createIterator(); iterator.hasNext();) {
				var groupString : String = String(iterator.next());

//				if(!GET_STYLE_NAME_AND_DECLARATIONS_PATTERN.test(groupString)) {
//					throw new CSSError("WRONG CSS FORMAT");
//				} else {
					var groups : Array = groupString.split("{");
					var groupName: String = StringUtil.trim(Objects.castToString(groups[0]));
					var groupContent : String = StringUtil.trim(Objects.castToString(groups[1]));
					var cssStylesGroup : CSSStylesGroup = new CSSStylesGroup(groupName);
					cssStylesGroup.styles.addItems(parseGroupContent(groupContent));
					result.addItem(cssStylesGroup);
//				}
			}
			return result;
		}
		
		private static function parseGroupContent(source : String) : ArrayList {
			var result : ArrayList = new ArrayList();
			var allStrings : Array = source.split(";");
			var valuesStrings : ArrayList = new ArrayList(allStrings.slice(0, allStrings.length-1));
			for(var iterator : IIterator = valuesStrings.createIterator(); iterator.hasNext();) {
				var valueString : String = String(iterator.next());
//				if(!GET_NAME_AND_VALUE.test(valueString)) {
//					throw new CSSError("org.goverla.serialization.css.CSSParser : BAD STYLE");
//				} else {
					var groups : Array = valueString.split(":");
					var groupName : String = StringUtil.trim(Objects.castToString(groups[0]));
					var groupContent : String = StringUtil.trim(Objects.castToString(groups[1]));
					var value : Object = groupContent;
					if(Strings.contains(groupContent, ",")) {
						value = parseStringToArrayWithoutWhiteSpace(groupContent, ",");
					}				
					var cssStyle : CSSStyle = new CSSStyle(groupName, value);
					result.addItem(cssStyle);
//				}	
			}
			return result;
		}	
		
		private static function parseStringToArrayWithoutWhiteSpace(source : String, delimiter : String) : Array {
			var result : Array = source.split(delimiter);
			for(var i:Number = 0; i < result.length; i++) {
				result[i] = Strings.removeWhiteSpaces(result[i]);	
			}
			return result;
		}
	
	}
}