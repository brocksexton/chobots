package org.goverla.controls.wizard.common {

	import mx.skins.ProgrammaticSkin;

	public class WizardBarSeparator extends ProgrammaticSkin {
		
		private static const ARROW_SIZE : Number = 3;

		protected override function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void {
			var w : Number = unscaledWidth;
			var h : Number = unscaledHeight;
			
			super.updateDisplayList(w, h);

			graphics.clear();

			graphics.lineStyle(1, 0x000000);

			graphics.moveTo(0, h / 2);
			graphics.lineTo(w, h / 2);
			graphics.lineTo(w - ARROW_SIZE, h / 2 - ARROW_SIZE);
			graphics.moveTo(w, h / 2);
			graphics.lineTo(w - ARROW_SIZE, h / 2 + ARROW_SIZE);
		}

	}

}