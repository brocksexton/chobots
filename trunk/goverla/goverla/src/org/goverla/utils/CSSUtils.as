package org.goverla.utils {

	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleClient;
	import mx.styles.StyleManager;
	
	import org.goverla.constants.StyleConstants;
	import org.goverla.constants.StyleNames;
	import org.goverla.utils.common.Pair;
	
	public class CSSUtils {	
		
		public static function getStyleDeclaration(className : String) : CSSStyleDeclaration {
			var result : CSSStyleDeclaration = StyleManager.getStyleDeclaration(className);
        	return (result != null) ? result : new CSSStyleDeclaration();
		}
		
        public static function setDefaultStyles(className : String, ...defaultStyles) : void {
        	var defaultStyleDeclaration : CSSStyleDeclaration =
        		(StyleManager.getStyleDeclaration(className) != null ?
        			StyleManager.getStyleDeclaration(className) :
        				new CSSStyleDeclaration());
        				
        	for each (var defaultStyle : Pair in defaultStyles) {
        		if (defaultStyleDeclaration.getStyle(defaultStyle.name) == null) {
	        		defaultStyleDeclaration.setStyle(defaultStyle.name, defaultStyle.value);
        		}
        	}
        	
        	StyleManager.setStyleDeclaration(className, defaultStyleDeclaration, true);
        }
        
		public static function setFont(component : IStyleClient, font : FontDescription) : void {
			component.setStyle(StyleNames.FONT_FAMILY, font.name);
			component.setStyle(StyleNames.FONT_SIZE, font.size);
			component.setStyle(StyleNames.COLOR, font.color);
			component.setStyle(StyleNames.TEXT_ALIGN, font.align);
			
			if (font.isBold) {
				component.setStyle(StyleNames.FONT_WEIGHT, StyleConstants.BOLD_FONT);
			} else {
				component.setStyle(StyleNames.FONT_WEIGHT, StyleConstants.NORMAL_FONT);
			}

			if (font.isItalic) {
				component.setStyle(StyleNames.FONT_STYLE, StyleConstants.ITALIC_FONT);
			} else {
				component.setStyle(StyleNames.FONT_STYLE, StyleConstants.NORMAL_FONT);
			}

			if (font.isUnderline) {
				component.setStyle(StyleNames.TEXT_DECORATION, StyleConstants.UNDERLINE_FONT);
			} else {
				component.setStyle(StyleNames.TEXT_DECORATION, StyleConstants.NONE);
			}
		}

	}

}