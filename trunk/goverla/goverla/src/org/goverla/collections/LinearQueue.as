package org.goverla.collections {

	import org.goverla.errors.CollectionError;
	import org.goverla.interfaces.IQueue;

	public class LinearQueue implements IQueue {

		protected var data : Array;

		public function LinearQueue(source : Array = null) {
			data = (source || []);
		}

		public function enqueue(item : Object) : void {
			data.push(item);
		}

		public function dequeue() : Object {
			if(isEmpty()) {
				throw new CollectionError("Cannot dequeue from an empty queue.");
			}
			return data.shift();
		}

		public function clear() : void {
			data = [];
		}

		public function isEmpty() : Boolean {
			return (data.length == 0);
		}
	}
}