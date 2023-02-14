package com.kavalok.gameChess
{
	import com.kavalok.gameChess.actions.ActionBase;
	import com.kavalok.gameChess.actions.CastlingAction;
	import com.kavalok.gameChess.actions.ForcePawnHitAction;
	import com.kavalok.gameChess.actions.ForcePawnMoveAction;
	import com.kavalok.gameChess.actions.HitAction;
	import com.kavalok.gameChess.actions.MoveAction;
	import com.kavalok.struct.Array2D;
	import com.kavalok.struct.IntPoint;
	
	public class ChessStrategy extends Controller
	{
		static public const NORMAL:String = 'normal';
		static public const MAT:String = 'mat';
		static public const PAT:String = 'pat';
		
		private var _cells:Array2D = game.cells;
		private var _items:Array = game.items;
		
		//{ region actions
		private function getAllActions():Array
		{
			var result:Array = [];
			var items:Array = game.getMyItems();
			for each (var item:Item in items)
			{
				result = result.concat(getActionsForItem(item));
			}
			return result;
		}
		
		public function getActionsForItem(item:Item):Array
		{
			if (item.type == Chess.BISHOP)	return getActionsForBishop(item);
			if (item.type == Chess.KING)	return getActionsForKing(item);
			if (item.type == Chess.KNIGHT)	return getActionsForKnight(item);
			if (item.type == Chess.PAWN)	return getActionsForPawn(item);
			if (item.type == Chess.QUEEN)	return getActionsForQueen(item);
			if (item.type == Chess.ROOK)	return getActionsForRook(item);
			return null;
		}
		
		private function getActionsForPawn(item:Item):Array
		{
			var result:Array = [];
			
			var direction:int = item.atBottom ? -1 : 1;
			
			var front1:Cell = getCell(item.row + direction, item.col);
			var front2:Cell = getCell(item.row + 2 * direction, item.col);
			var side1:Cell = getCell(item.row + direction, item.col - 1);
			var side2:Cell = getCell(item.row + direction, item.col + 1);
			
			if (isEmpty(front1))
				result.push(createAction(MoveAction, item, front1));
				
			if (!item.isMoved && isEmpty(front1) && isEmpty(front2))
				result.push(createAction(ForcePawnMoveAction, item, front2));
				
			if (isHis(side1) && item.isMy || isMy(side1) && !item.isMy)
				result.push(createAction(HitAction, item, side1));
				
			if (isHis(side2) && item.isMy || isMy(side2) && !item.isMy)
				result.push(createAction(HitAction, item, side2));
				
			if (item.isMy && client.forcePawnData)
			{
				var forcedItem:Item = _items[client.forcePawnData.id];
				
				if (forcedItem.row == item.row && forcedItem.col == item.col - 1)
					result.push(createAction(ForcePawnHitAction, item, side1));
				
				if (forcedItem.row == item.row && forcedItem.col == item.col + 1)
					result.push(createAction(ForcePawnHitAction, item, side2));
			}
			
			return result;
		}
		
		private function getActionsForRook(item:Item):Array
		{
			var result:Array = [];
			result = result.concat(getActionLine(item, Array2D.DIR_BOTTOM));
			result = result.concat(getActionLine(item, Array2D.DIR_LEFT));
			result = result.concat(getActionLine(item, Array2D.DIR_RIGHT));
			result = result.concat(getActionLine(item, Array2D.DIR_TOP));
			return result;
		}
		
		private function getActionsForBishop(item:Item):Array
		{
			var result:Array = [];
			result = result.concat(getActionLine(item, Array2D.DIR_BOTTOM_LEFT));
			result = result.concat(getActionLine(item, Array2D.DIR_BOTTOM_RIGHT));
			result = result.concat(getActionLine(item, Array2D.DIR_TOP_LEFT));
			result = result.concat(getActionLine(item, Array2D.DIR_TOP_RIGHT));
			return result;
		}
		
		private function getActionsForQueen(item:Item):Array
		{
			var result:Array = [];
			result = result.concat(getActionsForRook(item));
			result = result.concat(getActionsForBishop(item));
			return result;
		}
		
		private function getActionsForKnight(item:Item):Array
		{
			var cells:Array = [];
			var result:Array = [];
			
			cells.push(getCell(item.row + 2, item.col + 1));
			cells.push(getCell(item.row + 2, item.col - 1));
			cells.push(getCell(item.row - 2, item.col + 1));
			cells.push(getCell(item.row - 2, item.col - 1));
			cells.push(getCell(item.row + 1, item.col + 2));
			cells.push(getCell(item.row - 1, item.col + 2));
			cells.push(getCell(item.row + 1, item.col - 2));
			cells.push(getCell(item.row - 1, item.col - 2));
			
			for each (var cell:Cell in cells)
			{
				if (isEmpty(cell))
					result.push(createAction(MoveAction, item, cell));
				else if (isHis(cell) && item.isMy || isMy(cell) && !item.isMy)
					result.push(createAction(HitAction, item, cell));
			}
			return result;
		}
		
		private function underAttack(cell:Cell):Boolean
		{
			return getAttackersForCell(cell).length > 0;
		}
		
		private function getActionsForKing(item:Item):Array
		{
			var cells:Array = [];
			var result:Array = [];
			
			cells.push(getCell(item.row - 1, item.col - 1));
			cells.push(getCell(item.row - 1, item.col + 0));
			cells.push(getCell(item.row - 1, item.col + 1));
			cells.push(getCell(item.row + 1, item.col - 1));
			cells.push(getCell(item.row + 1, item.col + 0));
			cells.push(getCell(item.row + 1, item.col + 1));
			cells.push(getCell(item.row - 0, item.col - 1));
			cells.push(getCell(item.row - 0, item.col + 1));
			
			for each (var cell:Cell in cells)
			{
				if (isEmpty(cell))
					result.push(createAction(MoveAction, item, cell));
				else if (isHis(cell) && item.isMy || isMy(cell) && !item.isMy)
					result.push(createAction(HitAction, item, cell));
			}
			
			if (item.isMy && !item.isMoved)
			{
				var rookCell:Cell = getCell(item.row, 0);
				var cell0:Cell = getCell(item.row, item.col);
				var cell1:Cell = getCell(item.row, item.col - 1);
				var cell2:Cell = getCell(item.row, item.col - 2);
				var cell3:Cell = getCell(item.row, item.col - 3);
				var rook:Item = rookCell.item;
				
				if (rook && !rook.isMoved
					&& isEmpty(cell1) && isEmpty(cell2) && isEmpty(cell3)
					&& !underAttack(cell0) && !underAttack(cell1) && !underAttack(cell2))
				{
					result.push(createAction(CastlingAction, item, cell2));
				}
				
				rookCell = getCell(item.row, 7);
				cell1 = getCell(item.row, item.col + 1);
				cell2 = getCell(item.row, item.col + 2);
				rook = rookCell.item;
				
				if (rook && !rook.isMoved
					&& isEmpty(cell1) && isEmpty(cell2)
					&& !underAttack(cell0) && !underAttack(cell1) && !underAttack(cell2))
				{
					result.push(createAction(CastlingAction, item, cell2));
				}
			}
			
			return result;
		}
		
		private function getActionLine(itemFrom:Item, direction:IntPoint):Array
		{
			var result:Array = [];
			var line:Array = _cells.getLine(itemFrom.row, itemFrom.col, direction);
			
			for (var i:int = 1; i < line.length; i++)
			{
				var cell:Cell = line[i];
				if (cell.isEmpty)
					result.push(createAction(MoveAction, itemFrom, cell));
				else if (isHis(cell) && itemFrom.isMy || isMy(cell) && !itemFrom.isMy)
					result.push(createAction(HitAction, itemFrom, cell));
					
				if (!cell.isEmpty)
					break;
			}
			
			return result;
		}
		//} endregion
		
		public function getCellsForItem(item:Item):Array
		{
			var result:Array = [];
			var actions:Array = getActionsForItem(item);
			for each (var action:ActionBase in actions)
			{
				result.push(action.targetCell);
			}
			return result;
		}
		
		public function getState():String
		{
			var actions:Array = getEnabledActions();
			//trace(actions.length);
			if (actions.length > 0)
				return NORMAL;
			else if (isChack())
				return MAT;
			else
				return PAT;
		}
		
		public function getAttackersForKing():Array
		{
			var cell:Cell = game.getCellByItem(game.myKing);
			return getAttackersForCell(cell);
		}
		
		public function getAttackersForCell(cell:Cell):Array
		{
			var result:Array = [];
			var items:Array = game.getHisItems();
			
			for each (var item:Item in items)
			{
				var actions:Array = getActionsForItem(item);
				for each (var action:ActionBase in actions)
				{
					if (action.targetCell == cell)
					{
						result.push(item);
						break;
					}
				}
			}
			return result;
		}
		
		private function isChack():Boolean
		{
			return getAttackersForKing().length > 0;
		}
		
		private function getEnabledActions():Array
		{
			var result:Array = [];
			var actions:Array = getAllActions();
			for each (var action:ActionBase in actions)
			{
				action.execute();
				if (!isChack())
					result.push(action);
				action.undo();
			}
			return result;
		}
		
		public function getActionFor(item:Item, cell:Cell):ActionBase
		{
			var actions:Array = getActionsForItem(item);
			for each (var action:ActionBase in actions)
			{
				if (action.targetCell == cell)
					return action;
			}
			return null;
		}
		
		//{ region helpers
		private function isEmpty(cell:Cell):Boolean
		{
			return cell && cell.isEmpty;
		}
		
		private function isMy(cell:Cell):Boolean
		{
			return cell && cell.isMy;
		}
		
		private function isHis(cell:Cell):Boolean
		{
			return cell && cell.isHis;
		}
		
		private function getCell(row:int, col:int):Cell
		{
			return _cells.containsIndex(row, col)
				? _cells.getItem(row, col) as Cell
				: null;
		}
		
		private function createAction(classRef:Class, item:Item, target:Cell):ActionBase
		{
			var action:ActionBase = new classRef();
			action.sourceCell = game.getCellByItem(item);
			action.targetCell = target;
			return action;
		}
		//} endregion
	}
	
}