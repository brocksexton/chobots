package org.goverla.controls {

	import mx.controls.LinkButton;
	
	import org.goverla.constants.StyleNames;
	import org.goverla.skins.ExtendedLinkButtonSkin;
	import org.goverla.utils.CSSUtils;
	import org.goverla.utils.common.Pair;

	[Style(name="upBackgroundColor", type="uint", format="Color", inherit="yes")]
	
	[Style(name="upBackgroundAlpha", type="Number", inherit="yes")]

	[Style(name="rollOverAlpha", type="Number", inherit="yes")]

	[Style(name="selectionAlpha", type="Number", inherit="yes")]

	[Style(name="disabledBackgroundColor", type="uint", format="Color", inherit="yes")]
	
	[Style(name="disabledBackgroundAlpha", type="Number", inherit="yes")]

	public class ExtendedLinkButton extends LinkButton {

		private static const CLASS_NAME : String = "ExtendedLinkButton";
		
		private static var classConstructed : Boolean = staticConstructor();

		public function ExtendedLinkButton() {
			super();
		}
		
        private static function staticConstructor() : Boolean {
        	CSSUtils.setDefaultStyles(CLASS_NAME,
        		new Pair(StyleNames.UP_SKIN, ExtendedLinkButtonSkin),
	            new Pair(StyleNames.OVER_SKIN, ExtendedLinkButtonSkin),
	            new Pair(StyleNames.DOWN_SKIN, ExtendedLinkButtonSkin),
	            new Pair(StyleNames.DISABLED_SKIN, ExtendedLinkButtonSkin),
                new Pair(StyleNames.UP_BACKGROUND_COLOR, 0x000000),
                new Pair(StyleNames.UP_BACKGROUND_ALPHA, 0),
                new Pair(StyleNames.ROLL_OVER_ALPHA, 0),
                new Pair(StyleNames.SELECTION_ALPHA, 0),
                new Pair(StyleNames.DISABLED_BACKGROUND_COLOR, 0x000000),
                new Pair(StyleNames.DISABLED_BACKGROUND_ALPHA, 0));
        	
            return true;
        }

	}

}