package org.goverla.controls.wizard
{
	import org.goverla.controls.wizard.common.WizardBarSeparator;
	
	import flash.events.Event;
	
	import mx.controls.Button;
	import mx.controls.LinkBar;
	import mx.events.FlexEvent;
	import mx.skins.halo.LinkSeparator;

	public class WizardBar extends LinkBar
	{
		public function WizardBar() {
			super();
			setStyle("separatorSkin", WizardBarSeparator);
			setStyle("fontWeight", "normal");
		}
		
		protected override function hiliteSelectedNavItem(index : int) : void {
			super.hiliteSelectedNavItem(index);
			
			var child : Button = Button(getChildAt(index));
			child.setStyle("fontWeight", "bold");
		}		
	}
}