package org.goverla.interfaces {

	public interface IQueue	{
		
		function enqueue(item : Object) : void;

		function dequeue() : Object;

		function isEmpty() : Boolean;

	}

}