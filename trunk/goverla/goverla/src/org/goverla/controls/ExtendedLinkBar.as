package org.goverla.controls {

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.containers.ViewStack;
	import mx.controls.Button;
	import mx.controls.LinkBar;
	import mx.core.IFlexDisplayObject;
	import mx.events.FlexEvent;
	import mx.styles.ISimpleStyleClient;
	
	import org.goverla.constants.StyleNames;

	[Style(name="upBackgroundColor", type="uint", format="Color", inherit="yes")]
	
	[Style(name="upBackgroundAlpha", type="Number", inherit="yes")]

	[Style(name="rollOverAlpha", type="Number", inherit="yes")]

	[Style(name="selectionAlpha", type="Number", inherit="yes")]

	[Style(name="disabledBackgroundColor", type="uint", format="Color", inherit="yes")]
	
	[Style(name="disabledBackgroundAlpha", type="Number", inherit="yes")]

	public class ExtendedLinkBar extends LinkBar {

		protected static const SEPARATOR_NAME : String = "_separator";

		override public function set selectedIndex(value : int) : void {
			if (value == -1) {
				if (super.selectedIndex != -1 && super.selectedIndex < numChildren) {
					var button : Button = Button(getChildAt(super.selectedIndex))
					button.enabled = true;
				}
				dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
			} else if (selectedIndex < numChildren) {
				super.selectedIndex = value;
			}
		}
		
		public function get toggle() : Boolean {
			return _toggle;
		}
		
		public function set toggle(toggle : Boolean) : void {
			_toggle = toggle;
		}
		
		public function ExtendedLinkBar() {
			super();
			
			setStyle(StyleNames.PADDING_TOP, 0);
			setStyle(StyleNames.PADDING_BOTTOM, 0);
		}
		
		override protected function clickHandler(event : MouseEvent) : void {
			var index : int = getChildIndex(Button(event.currentTarget));
			if (!(dataProvider is ViewStack) && toggle) {
				hiliteSelectedNavItem(index);
			}
			super.clickHandler(event);
		}
		
		override protected function createNavItem(label : String, icon : Class = null) : IFlexDisplayObject {
			var pagerLinkButton : ExtendedLinkButton = new ExtendedLinkButton();
			pagerLinkButton.styleName = this;
			if (label != null && label != "") {
				pagerLinkButton.label = label;
			} else {
				pagerLinkButton.label = " ";
			}
			if (icon) {
				pagerLinkButton.setStyle("icon", icon);
			}
			addChild(pagerLinkButton);
			pagerLinkButton.addEventListener(MouseEvent.CLICK, clickHandler);
			var separatorClass : Class = Class(getStyle("separatorSkin"));
			var separator : DisplayObject = DisplayObject(new separatorClass());
			separator.name = SEPARATOR_NAME + (numChildren - 1);
			if (separator is ISimpleStyleClient) {
				ISimpleStyleClient(separator).styleName = this;
			}
			rawChildren.addChild(separator);
			return pagerLinkButton;
		}
		
		private var _toggle : Boolean;
		
	}

}