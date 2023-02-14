package org.goverla.containers {

	import flash.display.GradientType;
	import flash.geom.Rectangle;
	
	import mx.containers.Box;
	import mx.graphics.GradientEntry;
	import mx.graphics.IFill;
	import mx.graphics.LinearGradient;
	import mx.graphics.RadialGradient;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	[Style(name="fillType", type="String", enumeration="linear,radial", inherit="no")]
	[Style(name="fillColors", type="Array", format="Color", inherit="no")]
	[Style(name="fillAlphas", type="Array", format="Number", inherit="no")]
	[Style(name="fillRatios", type="Array", format="Number", inherit="no")]
	[Style(name="fillAngle", type="Number", inherit="no")]
	[Style(name="fillFocalPointRatio", type="Number", inherit="no")]
	public class GradientBox extends Box {

		private static const CLASS_NAME : String = "GradientBox";

		private static var classConstructed : Boolean = staticConstructor();
		
		public function GradientBox() {
			super();
		}
    
        private static function staticConstructor() : Boolean {
			var styleDeclaration : CSSStyleDeclaration =
				StyleManager.getStyleDeclaration(CLASS_NAME);
			if (!styleDeclaration) {
				styleDeclaration = new CSSStyleDeclaration();
			}
			styleDeclaration.defaultFactory = function() : void {
				this.fillType = GradientType.LINEAR;
				this.fillColors = null;
				this.fillAlphas = null;
				this.fillRatios = null;
				this.fillAngle = 90;
				this.fillFocalPointRatio = 0;
			}
			StyleManager.setStyleDeclaration(CLASS_NAME, styleDeclaration, false);
			return true;
        }
        
        override public function styleChanged(styleProp : String) : void {
			super.styleChanged(styleProp);

			var allStyles : Boolean = (styleProp == null || styleProp == "styleName");
			
			if (allStyles ||
				styleProp == "fillType" ||
				styleProp == "fillColors" ||
				styleProp == "fillAlphas" ||
				styleProp == "fillRatios" ||
				styleProp == "fillAngle" ||
				styleProp == "fillFocalPointRatio") {
				
				invalidateDisplayList();
			}
        }
    
        override protected function updateDisplayList(w : Number, h : Number) : void {
			super.updateDisplayList(w, h);
			
			graphics.clear();
			
			var fillType : String = (getStyle("fillType"));
			var fillColors : Array = (getStyle("fillColors") as Array);
			var fillAlphas : Array = (getStyle("fillAlphas") as Array);
			var fillRatios : Array = (getStyle("fillRatios") as Array);
			var fillAngle : Number = getStyle("fillAngle");
			var fillFocalPointRatio : Number = getStyle("fillFocalPointRatio");
			var cornerRadius : Number = getStyle("cornerRadius");
			
			if (fillColors != null) {
				if (fillAlphas == null) {
					fillAlphas = [];
				}
				
				if (fillRatios == null) {
					fillRatios = [];
				}
				
				for (var i : int = fillAlphas.length; i < fillColors.length; i++) {
					fillAlphas.push(1);
				}
				
				var lastFillRatioIndex : int = fillRatios.length - 1;
				var lastFillRatio : Number = fillRatios[lastFillRatioIndex];
				for (i = fillRatios.length; i < fillColors.length; i++) {
					fillRatios.push(lastFillRatio + (1 - lastFillRatio) * (i - lastFillRatioIndex) / (fillColors.length - lastFillRatioIndex));
				}
				
				var fillEntries : Array = [];
				for (i = 0; i < fillColors.length; i++) {
					fillEntries.push(new GradientEntry(fillColors[i], fillRatios[i], fillAlphas[i]));
				}
	
				var fill : IFill;
				switch (fillType) {
					case GradientType.LINEAR :
						fill = new LinearGradient();
						LinearGradient(fill).angle = fillAngle;
						LinearGradient(fill).entries = fillEntries;
						break;
					case GradientType.RADIAL :
						fill = new RadialGradient();
						RadialGradient(fill).angle = fillAngle;
						RadialGradient(fill).entries = fillEntries;
						RadialGradient(fill).focalPointRatio = fillFocalPointRatio;
						break;
				}
				fill.begin(graphics, new Rectangle(0, 0, w, h));
				graphics.drawRoundRect(0, 0, w, h, cornerRadius * 2, cornerRadius * 2);
				fill.end(graphics);
			}			
        }

	}

}