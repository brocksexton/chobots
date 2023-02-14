package com.kavalok.struct
{
	import com.kavalok.interfaces.IIterator;

	public class Array2DIterator implements IIterator
	{
		private var _array:Array;
		
		private var i:int = 0;
		private var j:int = 0;
		private var n:int;
		private var m:int;
		
		public function Array2DIterator(array:Array)
		{
			_array = array;
			
			n = array.length;
			m = (array[0] as Array).length;
		}

		public function hasNext():Boolean
		{
			return i < n && j < m;
		}
		
		public function next():Object
		{
			var result:Object = _array[i][j];
			
			j++;
			
			if (j == m)
			{
				j = 0;
				i++;
			}
			 
			return result;
		}
		
	}
}