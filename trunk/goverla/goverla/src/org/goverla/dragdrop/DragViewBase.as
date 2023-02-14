package org.goverla.dragdrop {
	
	import org.goverla.containers.CanvasWithChild;
	import org.goverla.dragdrop.interfaces.IDragView;

	public class DragViewBase extends CanvasWithChild implements IDragView {
		
		public function DragViewBase() {
			super();
			sizeByContent = true;
		}
		
		public function showError(message : String) : void {}
		
		public function clearError() : void {}
		
	}
	
}