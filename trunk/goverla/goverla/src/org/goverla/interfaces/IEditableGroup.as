package org.goverla.interfaces {

	public interface IEditableGroup extends IEditable {
		
		function addInstance(instance : IEditable) : void;
		
		function removeInstance(instance : IEditable) : void;
		
	}

}