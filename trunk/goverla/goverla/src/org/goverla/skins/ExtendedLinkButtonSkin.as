package org.goverla.skins {

	import mx.skins.halo.LinkButtonSkin;
	
	import org.goverla.constants.StyleNames;

	public class ExtendedLinkButtonSkin extends LinkButtonSkin {
		
		public function ExtendedLinkButtonSkin() {
			super();
		}
		
		override protected function updateDisplayList(w : Number, h : Number) : void {
			super.updateDisplayList(w, h);
			
			var cornerRadius : Number = getStyle(StyleNames.CORNER_RADIUS);
			
			switch (name) {
				case StyleNames.UP_SKIN :
					var backgroundColor : uint = getStyle(StyleNames.UP_BACKGROUND_COLOR);
					var backgroundAlpha : Number = getStyle(StyleNames.UP_BACKGROUND_ALPHA);
					break;
				case StyleNames.OVER_SKIN :
					backgroundColor = getStyle(StyleNames.ROLL_OVER_COLOR);
					backgroundAlpha = getStyle(StyleNames.ROLL_OVER_ALPHA);
					break;
				case StyleNames.DOWN_SKIN :
					backgroundColor = getStyle(StyleNames.SELECTION_COLOR);
					backgroundAlpha = getStyle(StyleNames.SELECTION_ALPHA);
					break;
				case StyleNames.DISABLED_SKIN :
					backgroundColor = getStyle(StyleNames.DISABLED_BACKGROUND_COLOR);
					backgroundAlpha = getStyle(StyleNames.DISABLED_BACKGROUND_ALPHA);
					break;
				default :
			}
			
			graphics.clear();
			drawRoundRect(2, 3, w - 4, h - 6, cornerRadius, backgroundColor, backgroundAlpha);
		}

	}

}