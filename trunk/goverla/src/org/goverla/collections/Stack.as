package org.goverla.collections {
	
	import org.goverla.errors.CollectionError;
	import org.goverla.interfaces.IQueue;

	public class Stack extends LinearQueue implements IQueue {
		
		public function Stack(source : Array = null) {
			super(source);
		}
		
		override public function dequeue() : Object {
			if (isEmpty()) {
				throw new CollectionError("Cannot dequeue from an empty queue");
			}
			return data.pop();
		}
		
	}
	
}