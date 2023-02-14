package com.kavalok.gameChess
{
	import com.kavalok.gameChess.actions.ActionBase;
	import com.kavalok.gameChess.actions.ForcePawnMoveAction;
	import com.kavalok.gameChess.data.ItemData;
	import com.kavalok.gameChess.view.DeskView;
	import com.kavalok.Global;
	import com.kavalok.struct.Array2D;
	import gameChess.SndTurn;
	
	public class DeskController extends Controller
	{
		static public const SIZE:int = 8;
		static public const BORDER_WIDTH:Number = 1;
		
		private var _desk:DeskView;
		private var _cells:Array2D = game.cells;
		private var _items:Array = game.items;
		private var _activeItem:Item;
		private var _strategy:ChessStrategy = new ChessStrategy();
		
		public function DeskController()
		{
			_desk = new DeskView();
			
			var cells:Array = _cells.getItems();
			for each (var cell:Cell in cells)
			{
				cell.pressEvent.addListener(onCellPress);
			}
			
			client.playerRemoveEvent.addListener(onPlayerRemoved);
			client.playerActivateEvent.addListener(onPlayerActivate);
			
			client.itemAddEvent.addListener(onItemAdded);
			client.itemActivateEvent.addListener(setActiveItem);
			client.itemMoveEvent.addListener(onItemMove);
			client.itemRemoveEvent.addListener(onItemRemove);
		}
		
		private function onItemAdded(data:ItemData):void
		{
			var item:Item = _items[data.id];
			
			if (item)
				removeItem(item.id);
				
			item = new Item(data);
			item.clickEvent.addListener(onItemPress);
			
			if (item.type == Chess.KING && item.isMy)
				game.myKing = item;
			
			_items[data.id] = item;
			_desk.addItem(item);
		}
		
		//{ region action
		private function onPlayerActivate(playerNum:int):void
		{
			if (playerNum == game.playerNum)
			{
				var state:String = _strategy.getState();
				if (state == ChessStrategy.MAT)
					client.sendFinish(game.otherPlayerNum);
				else if (state == ChessStrategy.PAT)
					client.sendFinish(-1);
				else
					startAction();
			}
		}
		
		private function onPlayerRemoved(playerNum:int):void
		{
			_desk.itemsEnabled = false;
		}
		
		private function startAction():void
		{
			_desk.itemsEnabled = true;
			_desk.setAttackers(_strategy.getAttackersForKing());
			_desk.updateCells();
		}
		
		private function finishAction():void
		{
			_desk.itemsEnabled = false;
			_desk.enabledCells = [];
			client.sendActivatePlayer(1 - game.playerNum);
		}
		//} endregion
		
		//{ region itemPress
		private function onItemPress(item:Item):void
		{
			if (item.isMy)
			{
				_desk.enabledCells = _strategy.getCellsForItem(item);
				_desk.setAttackers(_strategy.getAttackersForKing());
				client.sendActiveItem(item.data);
			}
			else
			{
				var cell:Cell = _cells.getItem(item.row, item.col) as Cell;
				if (cell.enabled)
					onCellPress(cell);
			}
		}
		
		private function setActiveItem(data:ItemData):void
		{
			if (_activeItem)
				_activeItem.selected = false;
				
			_activeItem = data ? _items[data.id] : null;
			
			if (_activeItem)
				_activeItem.selected = true;
		}
		//} endregion
		
		//{ region cell press
		private function onCellPress(cell:Cell):void
		{
			var action:ActionBase = _strategy.getActionFor(_activeItem, cell);
			action.execute();
			var attackers:Array = _strategy.getAttackersForKing();
			_desk.setAttackers(attackers);
			
			if (attackers.length == 0)
			{
				action.sendCommands();
				
				if (!(action is ForcePawnMoveAction) && client.forcePawnData)
					client.sendForcePawn(null);
				
				finishAction();
			}
			else
			{
				action.undo();
			}
		}
		//} endregion
		
		//{ region itemMove
		
		private function onItemMove(data:ItemData):void
		{
			Global.playSound(SndTurn);
			var item:Item = _items[data.id];
			item.data = data;
			item.isMoved = true;
			_desk.setItemPos(item);
		}
		
		private function onItemRemove(index:int):void
		{
			removeItem(index);
		}
		
		private function removeItem(index:int):void
		{
			_items[index] = null;
			_desk.removeItem(index);
		}
		//} endregion
		
	}
	
}