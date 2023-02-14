package org.goverla.controls.containers {

	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	
	import mx.containers.Box;
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import org.goverla.constants.StyleNames;
	import org.goverla.utils.GraphicsUtil;
	import org.goverla.utils.Objects;
	
	[Style(name="fillColors",type="Array",format="Color",inherit="no")]
	[Style(name="fillAlphas",type="Array",format="Number",inherit="no")]
	[Style(name="fillAngle",type="Number",inherit="no")]

	/**
	 *  Boolean property that controls the visibility
	 *  of the Box container's drop shadow.
	 *
	 *  @default false
	 */
	[Style(name="dropShadowEnabled", type="Boolean", inherit="no")]
	
	/**
	 *  Distance of drop shadow.
	 *  Negative values move the shadow above the panel.
	 *
	 *  @default 2
	 */
	[Style(name="shadowDistance", type="Number", format="Length", inherit="no")]

	/**
	 *  Angle of drop shadow.
	 *  and <code>"right"</code>.
	 *
	 *  @default 45
	 */
	[Style(name="shadowAngle", type="Number", inherit="no")]
	public class GradientBox extends Box {

		private static const CLASS_NAME : String = "GradientBox";
		
        private static var classConstructed : Boolean = staticConstructor();

        private var _isShadowChanged : Boolean = true;
        
		public function GradientBox() {
			super();
		}
    
        private static function staticConstructor():Boolean {
            if (!StyleManager.getStyleDeclaration(CLASS_NAME)) {
                var newStyleDeclaration : CSSStyleDeclaration = new CSSStyleDeclaration();
                newStyleDeclaration.setStyle(StyleNames.FILL_COLORS, [0xFFFFFF, 0x000000]);
                newStyleDeclaration.setStyle(StyleNames.FILL_ALPHAS, [0, 0]);
                newStyleDeclaration.setStyle(StyleNames.FILL_ANGLE, 90);
                newStyleDeclaration.setStyle(StyleNames.SHADOW_ANGLE, 45);
                StyleManager.setStyleDeclaration(CLASS_NAME, newStyleDeclaration, true);
            }
            return true;
        }
    
        private function get shadowFilter() : DropShadowFilter {
        	var shadowDistance : Number = Objects.castToNumber(getStyle(StyleNames.SHADOW_DISTANCE));
        	var shadowAngle : Number = Objects.castToNumber(getStyle(StyleNames.SHADOW_ANGLE));

            var color:Number = 0x000000;
            var alpha:Number = 0.8;
            var blurX:Number = 8;
            var blurY:Number = 8;
            var strength:Number = 0.65;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;

            return new DropShadowFilter(shadowDistance,
						            	shadowAngle,
										color,
										alpha,
										blurX,
										blurY,
										strength,
										quality,
										inner,
										knockout);
        }

        public override function styleChanged(styleProp : String) : void {
			switch(styleProp) {
            	case StyleNames.FILL_COLORS :
            	case StyleNames.FILL_ALPHAS :
            	case StyleNames.FILL_ANGLE :
				case StyleNames.CORNER_RADIUS:
		            super.styleChanged(styleProp);
	                invalidateDisplayList();
	                break;
				case StyleNames.DROP_SHADOW_ENABLED :
				case StyleNames.SHADOW_ANGLE :
				case StyleNames.SHADOW_DISTANCE :
					_isShadowChanged = true;
					invalidateDisplayList();
					break;
            }
        }
    
        protected override function updateDisplayList(unscaledWidth : Number, unscaledHeight:Number):void {
        	var w : Number = unscaledWidth;
        	var h : Number = unscaledHeight;

            super.updateDisplayList(w, h);

        	graphics.clear();

            var fillColors : Array = Objects.castToArray(getStyle(StyleNames.FILL_COLORS));
            if(fillColors == null) {
            	fillColors = [0, 0];
            }
            var fillAlphas : Array = Objects.castToArray(getStyle(StyleNames.FILL_ALPHAS));
            if(fillAlphas == null) {
            	fillAlphas = [0, 0];
            }
            var fillAngle : Number = getStyle(StyleNames.FILL_ANGLE);
            var cornerRadius : Number = Objects.castToNumber(getStyle(StyleNames.CORNER_RADIUS));

            var fill : LinearGradient = new LinearGradient();
            fill.angle = fillAngle;
		    fill.entries = [new GradientEntry(fillColors[0], 0, fillAlphas[0]), new GradientEntry(fillColors[1], 1, fillAlphas[1])];

		    GraphicsUtil.fillRect(graphics, fill, new Rectangle(0, 0, w, h), cornerRadius);

            if(_isShadowChanged) {
             	var dropShadowEnabled : Boolean = Objects.castToBoolean(getStyle(StyleNames.DROP_SHADOW_ENABLED));
           		var filter : DropShadowFilter = shadowFilter;
           		filters = (dropShadowEnabled ? [filter] : null);
            }
            
        }
		
	}

}