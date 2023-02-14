package org.goverla.containers {

	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.TitleWindow;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.effects.Resize;
	import mx.events.StateChangeEvent;
	import mx.states.SetProperty;
	import mx.states.State;
	import mx.states.Transition;
	
	import org.goverla.constants.Icons;
	import org.goverla.constants.StyleConstants;
	import org.goverla.constants.StyleNames;
	import org.goverla.events.CollapsablePanelEvent;
	import org.goverla.events.ResizeableLayoutEvent;
	import org.goverla.interfaces.IResizableLayoutChild;
	import org.goverla.utils.UIUtil;

	[Style(name="restoredStyleName", type="String", inherit="no")]
	
	[Style(name="collapsedStyleName", type="String", inherit="no")]
	
	public class CollapsablePanel extends TitleWindow implements IResizableLayoutChild {
		
		protected static const RESTORED_STATE : String = "";
		
		protected static const COLLAPSED_STATE : String = "collapsedState";
		
		protected static const RESTORED_STYLE_NAME : String = "restoredStyleName";
		
		protected static const COLLAPSED_STYLE_NAME : String = "collapsedStyleName";
		
		protected static const CLICK_TO_EXPAND : String = "Click to expand";
		
		protected static const CLICK_TO_COLLAPSE : String = "Click to collapse";
		
		protected static const RESTORED_ICON : Class = Icons.ICON_10X6_OPENED_UP;
		
		protected static const COLLAPSED_ICON : Class = Icons.ICON_10X6_CLOSED_UP;
		
		protected var setHeight : SetProperty;
		
		public function get collapsable() : Boolean {
			return _collapsable;
		}
		
		public function set collapsable(collapsable : Boolean) : void {
			_collapsable = collapsable;
			_collapsableChanged = true;
			invalidateProperties();
		}
		
		public function get collapsablePanelGroup() : CollapsablePanelGroup {
			return _collapsablePanelGroup;
		}
		
		public function set collapsablePanelGroup(value : CollapsablePanelGroup) : void {
			if (_collapsablePanelGroup != null) {
				_collapsablePanelGroup.removeInstance(this);
			}
			_collapsablePanelGroup = value;
			_collapsablePanelGroup.addInstance(this);
			_collapsablePanelGroupChanged = true;
			invalidateProperties();
		}
		
		public function get autoScrollManager() : AutoScrollManager {
			return _autoScrollManager;
		}
		
		public function set autoScrollManager(autoScrollManager : AutoScrollManager) : void {
			if (_autoScrollManager != null) {
				_autoScrollManager.removeInstance(this);
			}
			_autoScrollManager = autoScrollManager;
			_autoScrollManager.addInstance(this);
		}
		
		public function get collapsedIconSource() : Class {
			return _collapsedIconSource;
		}
		
		public function set collapsedIconSource(collapsedIconSource : Class) : void {
			_collapsedIconSource = collapsedIconSource;
			_collapsedIconSourceChanged = true;
			invalidateProperties();
		}
		
		public function get restoredIconSource() : Class {
			return _restoredIconSource;
		}
		
		public function set restoredIconSource(restoredIconSource : Class) : void {
			_restoredIconSource = restoredIconSource;
			_restoredIconSourceChanged = true;
			invalidateProperties();
		}
		
		public function get collapsed() : Boolean {
			return (currentState == COLLAPSED_STATE);
		}
		
		public function set collapsed(value : Boolean) : void {
			if (value) {
				collapse();
			} else {
				restore()
			}
		}
		
		public function get resizeable() : Boolean {
			return !collapsed;
		}
		
		public function get application() : UIComponent {
			return _application;
		}
		
		public function set application(value : UIComponent) : void {
			_application = value;
		}
		
		protected function get oppositeState() : String {
			return (collapsed ? RESTORED_STATE : COLLAPSED_STATE);
		}
		
		public function CollapsablePanel() {
			super();
			
			titleIcon = RESTORED_ICON;
			
			addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onCurrentStateChange);
			addEventListener(StateChangeEvent.CURRENT_STATE_CHANGING, onCurrentStateChanging);
		}
		
		public override function styleChanged(styleProp : String) : void {
			super.styleChanged(styleProp);
			
			var allStyles : Boolean = (styleProp == null || styleProp == "styleName");
			
			if (allStyles || styleProp == RESTORED_STYLE_NAME || styleProp == COLLAPSED_STYLE_NAME) {
				styleName = getStyleName();
			}
		}
		
		public function collapse() : void {
			changeCurrentState(COLLAPSED_STATE, false);
		}
		
		public function restore() : void {
			changeCurrentState(RESTORED_STATE, false);
		}
		
		protected override function createChildren() : void {
			super.createChildren();

			createCollapsedState();

			titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onTitleBarMouseDown);
			titleBar.addEventListener(MouseEvent.MOUSE_UP, onTitleBarMouseUp);
			titleBar.addEventListener(MouseEvent.MOUSE_OUT, onTitleBarMouseOut);
			titleBar.addEventListener(MouseEvent.MOUSE_OVER, onTitleBarMouseOver);
		}
		
		protected override function commitProperties() : void {
			super.commitProperties();
			
			if (_collapsableChanged || _collapsedIconSourceChanged || _restoredIconSourceChanged) {
				titleIcon = getTitleIcon();
			}
			
			if (_collapsableChanged || _collapsablePanelGroupChanged) {
				titleBar.toolTip = getTitleBarToolTip();
			}
			
			_collapsableChanged = false;
			_collapsablePanelGroupChanged = false;
			_collapsedIconSourceChanged = false;
			_restoredIconSourceChanged = false;
		}
		
		protected function setOppositeState() : void {
			if (collapsable) {
				changeCurrentState(oppositeState);
			}
		}
		
		protected function changeCurrentState(state : String, fireChange : Boolean = true) : void {
			if (state == RESTORED_STATE) {
				dispatchEvent(new ResizeableLayoutEvent(ResizeableLayoutEvent.OPEN));
			} else {
				dispatchEvent(new ResizeableLayoutEvent(ResizeableLayoutEvent.CLOSE));
			}
			currentState = state;
			if (fireChange) {
				dispatchEvent(new CollapsablePanelEvent(CollapsablePanelEvent.STATE_CHANGE));
			}
		}
		
		protected function onTitleBarMouseDown(event : MouseEvent) : void {
			_mousePosition = UIUtil.getApplicationMousePosition();
			if (!collapsed) {
				application.addEventListener(MouseEvent.MOUSE_MOVE, onApplicationMouseMove);
			}
		}
		
		protected function onApplicationMouseMove(event : MouseEvent) : void {
			application.removeEventListener(MouseEvent.MOUSE_MOVE, onApplicationMouseMove);
			dispatchEvent(new ResizeableLayoutEvent(ResizeableLayoutEvent.START_RESIZE, event.bubbles, event.cancelable,
				event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown));
		}
		
		// bugfix: titleBar always dispatches both click and mouseDown events
		protected function onTitleBarMouseUp(event : MouseEvent) : void {
			application.removeEventListener(MouseEvent.MOUSE_MOVE, onApplicationMouseMove);
			var shift : Point = UIUtil.getApplicationMouseShift(_mousePosition);
			if (shift.x == 0 && shift.y == 0) {
				setOppositeState();
			} else {
				dispatchEvent(new ResizeableLayoutEvent(ResizeableLayoutEvent.END_RESIZE, event.bubbles, event.cancelable,
					event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown));				
			}
		}
		
		protected function onTitleBarMouseOut(event : MouseEvent) : void {
			dispatchEvent(new ResizeableLayoutEvent(ResizeableLayoutEvent.RESIZE_MOUSE_OUT, event.bubbles, event.cancelable,
				event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown));
		}
		
		protected function onTitleBarMouseOver(event : MouseEvent) : void {
			dispatchEvent(new ResizeableLayoutEvent(ResizeableLayoutEvent.RESIZE_MOUSE_OVER, event.bubbles, event.cancelable,
				event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown));
		}
		
		protected function onCurrentStateChange(event : StateChangeEvent) : void {
			styleName = getStyleName();
			titleIcon = getTitleIcon();
			titleBar.toolTip = getTitleBarToolTip();
		}
		
		protected function onCurrentStateChanging(event : StateChangeEvent) : void {
			setHeight.value = getTitleBarHeight();
		}
		
		protected function getStyleName() : String {
			return (collapsed ? getStyle(COLLAPSED_STYLE_NAME) : getStyle(RESTORED_STYLE_NAME));
		}
		
		protected function getTitleIcon() : Class {
			var result : Class;
			if (collapsable) {
				result = (collapsed ? collapsedIconSource : restoredIconSource);
			}
			return result;
		}
		
		protected function getTitleBarToolTip() : String {
			var result : String;
			if (collapsable) {
				if (collapsed) {
					result = CLICK_TO_EXPAND;
				} else if (collapsablePanelGroup == null) {
					result = CLICK_TO_COLLAPSE;
				}
			}
			return result;
		}
		
		protected function getTitleBarHeight() : Number {
			return (titleBar.height + (getStyle(StyleNames.BORDER_STYLE) == 
				StyleConstants.BORDER_STYLE_SOLID ? getStyle(StyleNames.BORDER_THICKNESS) * 2 : 0));
		}
		
		private function createCollapsedState() : void {
			setHeight = new SetProperty(this, "height");

			var collapsedState : State = new State();
			collapsedState.name = COLLAPSED_STATE;
			collapsedState.overrides = [setHeight];
			
			states.push(collapsedState);
			
			var transition : Transition = new Transition();
			transition.effect = new Resize(this);
			transitions.push(transition);
		}

		private var _collapsable : Boolean = true;
		
		private var _collapsableChanged : Boolean;
		
		private var _collapsablePanelGroup : CollapsablePanelGroup;
		
		private var _collapsablePanelGroupChanged : Boolean;
		
		private var _autoScrollManager : AutoScrollManager;
		
		private var _collapsedIconSource : Class = COLLAPSED_ICON;
		
		private var _collapsedIconSourceChanged : Boolean = true;
		
		private var _restoredIconSource : Class = RESTORED_ICON;
		
		private var _restoredIconSourceChanged : Boolean = true;
		
		private var _mousePosition : Point;
		
		private var _application : UIComponent = UIComponent(Application.application);
		
	}

}