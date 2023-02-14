package com.kavalok.struct
{
	import com.kavalok.interfaces.IRequirement;
	
	public class Array2D
	{
		static public const DIR_TOP:IntPoint = new IntPoint(-1, 0);
		static public const DIR_LEFT:IntPoint = new IntPoint(0, -1);
		static public const DIR_RIGHT:IntPoint = new IntPoint(0, 1);
		static public const DIR_BOTTOM:IntPoint = new IntPoint(1, 0);
		static public const DIR_TOP_LEFT:IntPoint = new IntPoint(-1, -1);
		static public const DIR_TOP_RIGHT:IntPoint = new IntPoint(-1, 1);
		static public const DIR_BOTTOM_LEFT:IntPoint = new IntPoint(1, -1);
		static public const DIR_BOTTOM_RIGHT:IntPoint = new IntPoint(1, 1);
		
		protected var _numRows:int;
		protected var _numColumns:int;
		protected var _array:Array;
		
		public function Array2D(numRows:int, numColumns:int)
		{
			_numRows = numRows;
			_numColumns = numColumns;
			
			initArray();
		}
		
		protected function initArray():void
		{
			_array = new Array(_numRows);
			
			for (var i:int = 0; i < _numRows; i++)
			{
				_array[i] = new Array(_numColumns);
			}
		}
		
		public function getItem(row:int, column:int):Object
		{
			return _array[row][column];
		}
		
		public function containsIndex(row:int, column:int):Boolean
		{
			return (row >= 0 && row < _numRows && column >= 0 && column < _numColumns);
		}
		
		public function setItem(item:Object, row:int, col:int):void
		{
			_array[row][col] = item;
		}
		
		public function getItems(requirenment:IRequirement = null):Array
		{
			var iterator:Array2DIterator = getIterator();
			var result:Array = [];
			
			while (iterator.hasNext())
			{
				var item:Object = iterator.next();
				
				if (!requirenment || requirenment.meet(item)) 
					result.push(item);
			}
			
			return result;
		}
		
		public function getRow(row:int):Array
		{
			return (_array[row] as Array).slice();
		}
		
		public function getColumn(column:int):Array
		{
			var result:Array = [];
			
			for (var i:int = 0; i < _numRows; i++)
			{
				result.push(_array[i][column]);
			}
			
			return result;
		}
		
		public function getLine(fromRow:int, fromColumn:int, direction:IntPoint):Array
		{
			var result:Array = [];
			var i:int = fromRow;
			var j:int = fromColumn;
			
			while(containsIndex(i, j))
			{
				result.push(_array[i][j]);
				i += direction.i;
				j += direction.j;
			}
			
			return result;
		}
		
		public function get numRows():int
		{
			 return _numRows;
		}
		
		public function get numColumns():int
		{
			 return _numColumns;
		}
		
		public function get source():Array
		{
			return _array;
		}
		
		public function getIterator():Array2DIterator
		{
			return new Array2DIterator(_array);
		}

	}
}