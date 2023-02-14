package org.goverla.collections.iterators
{
	import org.goverla.collections.LinearQueue;
	import org.goverla.interfaces.IIterator;

	public class CustomTreeIterator implements IIterator
	{
		private var _queue : LinearQueue = new LinearQueue();
		private var _childrenField : String;
		
		public function CustomTreeIterator(source : Object, childrenField : String) {
			_childrenField = childrenField;
			_queue.enqueue(source);
		}
		
		public function hasNext():Boolean
		{
			return !_queue.isEmpty();
		}
		
		public function next():Object
		{
			var result : Object = _queue.dequeue();
			for each(var child : Object in result[_childrenField]) {
				_queue.enqueue(child);
			}
			return result;
		}
		
	}
}