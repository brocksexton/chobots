package org.goverla.containers {
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Box;
	import mx.containers.BoxDirection;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.goverla.events.ResizeableLayoutEvent;
	import org.goverla.interfaces.IResizableLayoutChild;
	import org.goverla.utils.UIUtil;

	public class ResizeableLayoutBox extends Box {
		
		public function get application() : UIComponent {
			return _application;
		}
		
		public function set application(value : UIComponent) : void {
			_application = value;
		}
		
		public function ResizeableLayoutBox() {
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function onCreationComplete(event : FlexEvent) : void {
			for (var i : int = 0; i < numChildren; i++) {
				var child : UIComponent = UIComponent(getChildAt(i));
				if (i != 0) {
					child.addEventListener(ResizeableLayoutEvent.START_RESIZE, onChildStartResize);
					child.addEventListener(ResizeableLayoutEvent.RESIZE_MOUSE_OUT, onChildMouseOut);
					child.addEventListener(ResizeableLayoutEvent.RESIZE_MOUSE_OVER, onChildMouseOver);
				}
				child.addEventListener(ResizeableLayoutEvent.CLOSE, onChildClose);
			}
		}
		
		protected function onChildStartResize(event : ResizeableLayoutEvent) : void {
			_resizingChildIndex = getChildIndex(UIComponent(event.target));
			_previousChildIndex = getPreviousChildIndex(_resizingChildIndex);
			
			if (_previousChildIndex >= 0) {
				updateChildrenSize(_previousChildIndex);
				
				if (direction == BoxDirection.VERTICAL) {
					_startSize = getChildAt(_previousChildIndex).height + getChildAt(_resizingChildIndex).height;
				} else {
					_startSize = getChildAt(_previousChildIndex).width + getChildAt(_resizingChildIndex).width;
				}
	
				_currentMousePosition = UIUtil.getApplicationMousePosition();
	
				application.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				application.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}
		
		protected function onMouseUp(event : MouseEvent) : void {
			_resizingChildIndex = -1;
			_previousChildIndex = -1;
			_startSize = NaN;
			_currentMousePosition = null;
			_childMouseOut = false;
			_previousMoveDirection = false;
			
			application.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			application.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		protected function onMouseMove(event : MouseEvent) : void {
			if (_resizingChildIndex != -1) {
				var shift : Point = UIUtil.getApplicationMouseShift(_currentMousePosition);
				_currentMousePosition = UIUtil.getApplicationMousePosition();
				
				var moveDirection : Boolean;
				if (direction == BoxDirection.VERTICAL) {
					moveDirection = shift.y > 0;
				} else {
					moveDirection = shift.x > 0;
				}
				
				if (moveDirection == _previousMoveDirection || !_childMouseOut) {
					setChildHeight(shift);
				}
				
				if (!_childMouseOut) {
					_previousMoveDirection = moveDirection;
				}
			}
		}
		
		protected function onChildMouseOut(event : ResizeableLayoutEvent) : void {
			if (_resizingChildIndex != -1 && event.target == getChildAt(_resizingChildIndex)) {
				_childMouseOut = true;
			}
		}
		
		protected function onChildMouseOver(event : ResizeableLayoutEvent) : void {
			if (_resizingChildIndex != -1 && event.target == getChildAt(_resizingChildIndex)) {
				_childMouseOut = false;
			}
		}
		
		protected function onChildClose(event : ResizeableLayoutEvent) : void {
			var closingChildIndex : int = getChildIndex(UIComponent(event.target));
			var flexibleChildIndex : int = getPreviousChildIndex(closingChildIndex);
			if (flexibleChildIndex == -1) {
				flexibleChildIndex = getNextChildIndex(closingChildIndex);
			}
			
			if (flexibleChildIndex != -1) {
				updateChildrenSize(flexibleChildIndex);
			}
		}
		
		private function setChildHeight(shift : Point) : void {
			var previousChild : UIComponent = UIComponent(getChildAt(_previousChildIndex));
			var child : UIComponent = UIComponent(getChildAt(_resizingChildIndex));
						
			if (direction == BoxDirection.VERTICAL) {
				if (shift.y < 0) {
					if (_startSize - (child.height - shift.y) > previousChild.minHeight) {
						child.height -= shift.y;
					}
				} else {
					if (child.height - shift.y > child.minHeight) {
						child.height -= shift.y;
					}					
				}
			} else {
				if (shift.x < 0) {
					if (_startSize - (child.width - shift.x) > previousChild.minWidth) {
						child.width -= shift.x;shift.y;
					}
				} else {
					if (child.width - shift.x > child.minWidth) {
						child.width -= shift.x;
					}					
				}
			}
		}
		
		private function getPreviousChildIndex(currentChildIndex : int) : int {
			if (currentChildIndex >= 0) {
				for (var i : int = currentChildIndex - 1; i >= 0; i--) {
					if (IResizableLayoutChild(getChildAt(i)).resizeable) {
						return i;
					}
				}
			}
			return -1;
		}
		
		private function getNextChildIndex(currentChildIndex : int) : int {
			if (currentChildIndex < numChildren - 1) {
				for (var i : int = currentChildIndex + 1; i < numChildren; i++) {
					if (IResizableLayoutChild(getChildAt(i)).resizeable) {
						return i;
					}
				}
			}
			return -1;
		}
		
		private function setFixedSize(child : DisplayObject) : void {
			if (direction == BoxDirection.VERTICAL) {
				child.height = child.height;
			} else {
				child.width = child.width;
			}
		}
		
		private function setFlexibleSize(child : DisplayObject) : void {
			if (direction == BoxDirection.VERTICAL) {
				UIComponent(child).percentHeight = 100;
			} else {
				UIComponent(child).percentWidth = 100;
			}
		}
		
		private function updateChildrenSize(flexibleChildIndex : int) : void {
			for (var i : uint = 0; i < numChildren; i++) {
				if (i == flexibleChildIndex) {
					setFlexibleSize(getChildAt(i));
				} else {
					var child : DisplayObject = getChildAt(i);
					if (IResizableLayoutChild(child).resizeable) {
						setFixedSize(child);
					}
				}
			}
		}
		
		private var _application : UIComponent = UIComponent(Application.application);
		
		private var _resizingChildIndex : int;
		
		private var _previousChildIndex : int;
		
		private var _startSize : Number;
		
		private var _currentMousePosition : Point;
		
		private var _childMouseOut : Boolean;
		
		private var _previousMoveDirection : Boolean;
		
	}
	
}