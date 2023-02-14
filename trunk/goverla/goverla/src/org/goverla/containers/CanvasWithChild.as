package org.goverla.containers {
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;

	public class CanvasWithChild extends Canvas {
		
		public var sizeByContent : Boolean = false;
		
		public function CanvasWithChild() {
			super();
			
			addEventListener(ResizeEvent.RESIZE, onResize);
		}

		public function get child() : UIComponent {
			return _child;
		}

		public function set child(child : UIComponent) : void {
			if (_child != null) {
				_child.removeEventListener(ResizeEvent.RESIZE, onChildResize);
			}
			_child = child;
			if (_child != null) {
				_child.addEventListener(ResizeEvent.RESIZE, onChildResize);
			}
			_childChanged = true;
			invalidateProperties();
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();

			if (_childChanged) {
				removeAllChildren();
				if (_child != null) {
					addChild(_child);
				}
			}
		}
		
		private function onResize(event : ResizeEvent) : void {
			adjustSize();
		}
		
		private function onChildResize(event : ResizeEvent) : void {
			adjustSize();
		}
		
		private function adjustSize() : void {
			if (sizeByContent) {
				width = _child.width;
				height = _child.height;
			} else {
				_child.width = width;
				_child.height = height;
			}
		}
		
		private var _child : UIComponent;

		private var _childChanged : Boolean;
	}
}