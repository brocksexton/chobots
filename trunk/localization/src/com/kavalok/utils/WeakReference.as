package com.kavalok.utils
{
	import com.kavalok.errors.IllegalStateError;
	
	import flash.utils.Dictionary;
	
	public class WeakReference
	{
		private var _dictionary : Dictionary = new Dictionary(true);
		
		public function WeakReference(value : Object, data : Object = true)
		{
			_dictionary[value] = data;
		}
		
		public function get data() : Object
		{
			return _dictionary[value];
		}
		
		public function get value() : Object
		{
			var result : Object;
			for(var obj : Object in _dictionary)
			{
				if(result != null)
				{
					throw new IllegalStateError("More than one value in weakReference");
				}
				result = obj;
			}
			return result;
		}
		
		public function get alive() : Boolean
		{
			return value != null;
		}

	}
}