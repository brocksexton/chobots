package org.goverla.utils.ui
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class InitialFocus
	{
		private var _focusedComponentField : String;
		public function InitialFocus(document : UIComponent, focusedComponentField : String) {
			document.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			_focusedComponentField = focusedComponentField;
		}
		
		private function onCreationComplete(event : FlexEvent) : void {
			UIComponent(event.target).removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			UIComponent(event.currentTarget[_focusedComponentField]).setFocus();
		}
		
		
	}
}