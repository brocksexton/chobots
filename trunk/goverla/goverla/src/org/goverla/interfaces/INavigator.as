package org.goverla.interfaces {
	
	public interface INavigator	{
		
		function get hasPrev() : Boolean;
		
		function get hasNext() : Boolean;
		
		function moveFirst() : void;
		
		function moveLast() : void;
		
		function movePrev() : void;
		
		function moveNext() : void;
		
	}
}