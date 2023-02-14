package com.kavalok.gameCheckers
{
	import com.kavalok.gameCheckers.view.Cell;
	import com.kavalok.gameCheckers.view.DeskView;
	import com.kavalok.gameCheckers.view.Item;
	import com.kavalok.utils.GraphUtils;
	
	public class DeskStrategy
	{
		static private const SIZE:int = DeskView.SIZE;
		
		static private const TOP_LEFT:IntVector = new IntVector(-1, -1);
		static private const TOP_RIGHT:IntVector = new IntVector(-1, 1);
		static private const BOTTOM_LEFT:IntVector = new IntVector(1, -1);
		static private const BOTTOM_RIGHT:IntVector = new IntVector(1, 1);
		
		private var _cells:Array;
		private var _items:Array;
		
		public function DeskStrategy(cells:Array, items:Array)
		{
			_cells = cells;
			_items = items;
		}
		
		public function getEnabledItems():Array
		{
			var result:Array = [];
			var myItems:Array = getMyItems();
			var itemsWithEnemies:Array = getItemsWithEnemies(myItems);
			
			if (itemsWithEnemies.length > 0)
			{
				result = itemsWithEnemies;
			}
			else
			{
				for each (var item:Item in myItems)
				{
					if (getEnabledCells(item).length > 0)
						result.push(item);
				}
			}
				
			return result;
		}
		
		//{ region enemies
		private function getItemsWithEnemies(items:Array):Array
		{
			var result:Array = [];
			
			for each (var item:Item in items)
			{
				var enemies:Array = findEnemiesForItem(item);
				if (enemies.length > 0)
					result.push(item);
			}
			
			return result;
		}
		
		public function findEnemiesForItem(itemFor:Item):Array
		{
			return findEnemies(itemFor.row, itemFor.col, itemFor.isKing);
		}
		
		public function findEnemies(row:int, col:int, isKing:Boolean):Array
		{
			var result:Array = [];
			result = result.concat(findEnemiesIn(row, col, isKing, TOP_LEFT));
			result = result.concat(findEnemiesIn(row, col, isKing, TOP_RIGHT));
			result = result.concat(findEnemiesIn(row, col, isKing, BOTTOM_LEFT));
			result = result.concat(findEnemiesIn(row, col, isKing, BOTTOM_RIGHT));
			
			return result;
		}
		
		private function findEnemiesIn(row:int, col:int, isKing:Boolean, direction:IntVector):Array
		{
			var diagonal:Array = getDiagonal(row, col, direction);
			
			if (isKing)
			{
				while (isEmpty(diagonal[0]))
				{
					diagonal.shift();
				}
			}
			
			var first:Cell = diagonal[0];
			var next:Cell = diagonal[1];
			
			return (isHis(first) && isEmpty(next))
				? [first.item]
				: [];
		}
		//} endregion
		
		//{ region enabled cells
		public function getEnabledCells(itemFor:Item):Array
		{
			var result:Array = [];
			
			if (itemFor.isKing)
			{
				result = result.concat(findForKing(itemFor, TOP_LEFT));
				result = result.concat(findForKing(itemFor, TOP_RIGHT));
				result = result.concat(findForKing(itemFor, BOTTOM_LEFT));
				result = result.concat(findForKing(itemFor, BOTTOM_RIGHT));
			}
			else
			{
				var atBottom:Boolean = itemFor.atBottom;
				result = result.concat(findForRegular(itemFor, TOP_LEFT, atBottom));
				result = result.concat(findForRegular(itemFor, TOP_RIGHT, atBottom));
				result = result.concat(findForRegular(itemFor, BOTTOM_LEFT, !atBottom));
				result = result.concat(findForRegular(itemFor, BOTTOM_RIGHT, !atBottom));
			}
			
			return (findEnemiesForItem(itemFor).length == 0)
				? result
				: getCellsDeletedEnemies(itemFor, result);
		}
		
		private function getCellsDeletedEnemies(itemFor:Item, cells:Array):Array
		{
			var result:Array = [];
			var result2:Array = [];
			
			for each (var cell:Cell in cells)
			{
				if (getDeletedItems(itemFor, cell).length > 0)
				{
					result.push(cell);
				
					if (findEnemies(cell.row, cell.col, itemFor.isKing).length > 1)
						result2.push(cell);
				}
			}
			
			return (result2.length > 0)
				? result2
				: result;
		}
		
		private function findForRegular(itemFor:Item, direction:IntVector, isForward:Boolean):Array
		{
			var diagonal:Array = getDiagonal(itemFor.row, itemFor.col, direction);
			var first:Cell = diagonal[0];
			var next:Cell = diagonal[1];
			
			if (isForward && isEmpty(first))
				return[first];
			else if (isHis(first) && isEmpty(next))
				return [next];
			else
				return [];
		}
		
		private function findForKing(itemFor:Item, direction:IntVector):Array
		{
			var diagonal:Array = getDiagonal(itemFor.row, itemFor.col, direction);
			var result:Array = [];
			
			while (isEmpty(diagonal[0]))
			{
				result.push(diagonal[0]);
				diagonal.shift();
			}
			
			if (isHis(diagonal[0]))
				diagonal.shift();
			
			while (isEmpty(diagonal[0]))
			{
				result.push(diagonal[0]);
				diagonal.shift();
			}
			
			return result;
		}
		//} endregion
		
		public function getDeletedItems(itemFor:Item, cellFor:Cell):Array
		{
			var result:Array = [];
			
			var di:int = GraphUtils.sign(cellFor.row - itemFor.row);
			var dj:int = GraphUtils.sign(cellFor.col - itemFor.col);
			
			var i:int = itemFor.row + di;
			var j:int = itemFor.col + dj;
			
			while (i != cellFor.row && j != cellFor.col)
			{
				var cell:Cell = _cells[i][j];
				if (isHis(cell))
					result.push(cell.item);
					
				i += di;
				j += dj;
			}
			
			return result;
		}
		
		private function getDiagonal(row:int, col:int, direction:IntVector):Array
		{
			var result:Array = [];
			
			var i:int = row + direction.i;
			var j:int = col + direction.j;
			
			while (i >= 0 && i < SIZE && j >= 0 && j < SIZE)
			{
				result.push(_cells[i][j]);
				
				i += direction.i;
				j += direction.j;
			}
			
			return result;
		}
		
		
		//{ region helpers
		public function getMyItems():Array
		{
			return getItemsByPlayer(true);
		}
		
		public function getHisItems():Array
		{
			return getItemsByPlayer(false);
		}
		
		private function getItemsByPlayer(isMy:Boolean):Array
		{
			var result:Array = [];
			
			for each (var item:Item in _items)
			{
				if (item && item.isMy == isMy)
					result.push(item);
			}
			
			return result;
		}
		
		private function isEmpty(cell:Cell):Boolean
		{
			return (cell && cell.state == CellStates.EMPTY);
		}
		
		private function isMy(cell:Cell):Boolean
		{
			return (cell && cell.state == CellStates.MY);
		}
		
		private function isHis(cell:Cell):Boolean
		{
			return (cell && cell.state == CellStates.HIS);
		}
		
		//} endregion
	}
	
}