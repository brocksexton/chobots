package org.goverla.containers {

	import mx.core.IFlexDisplayObject;

	public class EditablePanelGroup extends CollapsablePanelGroup {

		public function EditablePanelGroup(document : IFlexDisplayObject = null) {
			super(document);
		}
		
		override public function get selection() : CollapsablePanel {
			return _selection;
		}
		
		override public function set selection(selection : CollapsablePanel) : void {
			var panel : CollapsablePanel;
			
			if (EditablePanel(selection).editing) {
				_selection = selection;
			} else {
				_selection = null;
				for each (panel in collapsablePanels) {
					if (EditablePanel(panel).editing) {
						_selection = panel;
						break;
					}
				}
			}
			for each (panel in collapsablePanels) {
				if (_selection != null) {
					if (panel == _selection) {
						panel.restore();
					} else {
						panel.collapse();
					}
				} else {
					panel.restore();
				}
			}
		}
		
		private var _selection : CollapsablePanel;
		
	}

}