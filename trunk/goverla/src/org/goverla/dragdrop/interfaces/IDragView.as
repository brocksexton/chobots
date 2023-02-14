package org.goverla.dragdrop.interfaces {
	import mx.core.IFlexDisplayObject;
	

	public interface IDragView extends IFlexDisplayObject {
		
		function showError(message : String) : void;
		
		function clearError() : void;
	}
}