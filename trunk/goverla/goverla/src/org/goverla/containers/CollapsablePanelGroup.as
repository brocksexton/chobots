package org.goverla.containers {
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.core.IMXMLObject;
	
	import org.goverla.events.CollapsablePanelEvent;

	public class CollapsablePanelGroup extends EventDispatcher implements IMXMLObject {
		
		protected var collapsablePanels : ArrayCollection = new ArrayCollection();
		
		public function CollapsablePanelGroup(document : IFlexDisplayObject = null) {
			super();
		}
		
		public function get selection() : CollapsablePanel {
			return _selection;
		}
		
		public function set selection(selection : CollapsablePanel) : void {
			if (collapsablePanels.contains(selection)) {
				if (_selection) {
					_selection.collapse();
				}
				_selection = selection;
				_selection.restore();
			}
		}

		public function initialized(document : Object, id : String) : void {
			_document = document ? IFlexDisplayObject(document) : IFlexDisplayObject(Application.application);
		}
		
		public function addInstance(collapsablePanel : CollapsablePanel) : void {
			if (!collapsablePanels.contains(collapsablePanel)) {
				collapsablePanel.addEventListener(CollapsablePanelEvent.STATE_CHANGE, onCollapsablePanelStateChange);
				collapsablePanels.addItem(collapsablePanel);
				if (selection == null && !collapsablePanel.collapsed) {
					selection = collapsablePanel;
				} else {
					collapsablePanel.collapse();
				}
			}
		}
		
		public function removeInstance(collapsablePanel : CollapsablePanel) : void {
			if (collapsablePanels.contains(collapsablePanel)) {
				collapsablePanel.removeEventListener(CollapsablePanelEvent.STATE_CHANGE, onCollapsablePanelStateChange);
				collapsablePanels.removeItemAt(collapsablePanels.getItemIndex(collapsablePanel));
			}
		}
		
		protected function onCollapsablePanelStateChange(event : CollapsablePanelEvent) : void {
			selection = CollapsablePanel(event.target);
		}
		
		private var _document : IFlexDisplayObject;
		
		private var _selection : CollapsablePanel;
		
	}

}