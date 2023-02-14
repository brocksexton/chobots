package org.goverla.dragdrop.interfaces {
	import org.goverla.dragdrop.common.DropAcceptance;
	
	import mx.core.IFlexDisplayObject;
	import mx.core.IUIComponent;
	
	public interface IDragDropSubject extends IUIComponent {
		
		function acceptDrop(dragInformation : Object ) : DropAcceptance;
	
		function doDrop(dragInformation : Object) : void;
	
		function dropAccepted(dragInformation : Object) : void; 
		
	}
}