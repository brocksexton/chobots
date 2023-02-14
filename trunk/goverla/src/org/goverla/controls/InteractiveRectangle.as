package org.goverla.controls {

	import mx.core.UIComponent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	[Style(name="borderStyle", type="String", enumeration="none,solid")]
	
	[Style(name="borderThickness", type="Number", format="Length")]
	
	[Style(name="borderColor", type="uint", format="Color")]
	
	[Style(name="backgroundColor", type="uint", format="Color")]
	
	[Style(name="backgroundAlpha", type="Number")]
	
	public class InteractiveRectangle extends UIComponent {
		
		private static const CLASS_NAME : String = "InteractiveRectangle";
		
		private static var classContructed : Boolean = staticConstructor();
		
        private static function staticConstructor() : Boolean {
            if (!StyleManager.getStyleDeclaration(CLASS_NAME)) {
                var newStyleDeclaration : CSSStyleDeclaration = new CSSStyleDeclaration();
                newStyleDeclaration.setStyle("borderStyle", "none");
                newStyleDeclaration.setStyle("borderThickness", 1);
                newStyleDeclaration.setStyle("borderColor", 0xAAB3B3);
                newStyleDeclaration.setStyle("backgroundAlpha", 1);
                StyleManager.setStyleDeclaration(CLASS_NAME, newStyleDeclaration, true);
            }
            return true;
        }
        
		protected override function updateDisplayList(w : Number, h : Number) : void {
			var borderStyle : String = getStyle("borderStyle");
			var borderThickness : Number = getStyle("borderThickness");
			var borderColor : uint = getStyle("borderColor");
			var backgroundColor : uint = getStyle("backgroundColor");
			var backgroundAlpha : Number = getStyle("backgroundAlpha");
			graphics.clear();
			if (borderStyle == "solid") {
				graphics.lineStyle(borderThickness, borderColor);
			}
			graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.moveTo(0, 0);
			graphics.lineTo(w, 0);
			graphics.lineTo(w, h);
			graphics.lineTo(0, h);
			graphics.lineTo(0, 0);
			graphics.endFill();
		}
		
	}

}