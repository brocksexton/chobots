package com.kavalok.gameCheckers.view
{
	import com.kavalok.gameCheckers.Controller;
	import com.kavalok.gameCheckers.DeskStrategy;
	import com.kavalok.gameCheckers.data.ItemData;
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	import com.kavalok.utils.Timers;
	import gameCheckers.SndTurn;
	
	import flash.display.Sprite;
	
	import gameCheckers.McFieldDark;
	import gameCheckers.McFieldLight;
	import gameCheckers.McGameWindow;
	
	public class DeskView extends Controller
	{
		static public const SIZE:int = 8;
		static public const CELL_SIZE:int = 32;
		
		private var _content:Sprite = new Sprite;
		private var _cells:Array = [];
		private var _items:Array = [];
		private var _activeItem:Item;
		private var _strategy:DeskStrategy = new DeskStrategy(_cells, _items);
		private var _rotated:Boolean;
		
		public function DeskView(content:McGameWindow)
		{
			_rotated = (game.playerNum == 1);
			
			createCells();
			content.addChild(_content);
			GraphUtils.setCoords(_content, content.deskClip);
			
			if (_rotated)
			{
				_content.rotation = 180;
				_content.x = _content.x + _content.width - 1;
				_content.y = _content.y + _content.height - 1;
			}
			
			client.playerRemoveEvent.addListener(onPlayerRemoved);
			client.playerActivateEvent.addListener(onPlayerActivate);
			
			client.itemAddEvent.addListener(onItemAdded);
			client.itemActivateEvent.addListener(onItemActivate);
			client.itemMoveEvent.addListener(onItemMove);
			client.itemRemoveEvent.addListener(onItemRemove);
		}
		
		//{ region cell creation
		private function createCells():void
		{
			for (var i:int = 0; i < SIZE; i++)
			{
				_cells[i] = [];
				
				for (var j:int = 0; j < SIZE; j++)
				{
					var cell:Cell = ((i + j) % 2 == 0)
						? new Cell(McFieldLight, i, j)
						: new Cell(McFieldDark, i, j);
						
					cell.x = j * CELL_SIZE;
					cell.y = i * CELL_SIZE;
					cell.pressEvent.addListener(onCellPress);
					
					_content.addChild(cell);
					_cells[i][j] = cell;
				}
			}
		}
		
		private function onItemAdded(data:ItemData):void
		{
			var item:Item = _items[data.index];
			if (item)
				_content.removeChild(item);
			
			item = new Item(data);
			item.rotation = _rotated ? 180 : 0;

			setItemPos(item);
			
			if (item.isMy)
				item.pressEvent.addListener(onItemPress);

			_items[data.index] = item;
			_content.addChild(item);
		}
		//} endregion
		
		//{ region action
		private function onPlayerActivate(playerNum:int):void
		{
			if (playerNum == game.playerNum)
			{
				updateCells();
			
				var enabledItems:Array = _strategy.getEnabledItems();
			
				if (_strategy.getEnabledItems().length == 0)
				{
					client.sendVictory(1 - game.playerNum);
				}
				else
				{
					setItemsEnabled(enabledItems, true);
					setEnemiesSign(enabledItems);
				}
			}
		}
		
		private function onPlayerRemoved(playerNum:int):void
		{
			disableItems();
		}
		
		private function finishAction():void
		{
			disableItems();
			client.sendActivatePlayer(1 - game.playerNum);
		}
		//} endregion
		
		//{ region itemPress
		private function onItemPress(item:Item):void
		{
			updateCells();
			setActiveItem(item.data.index);
			setEnabledCells();
			client.sendActiveItem(item.data);
		}
		
		private function onItemActivate(data:ItemData):void
		{
			if (data.playerNum != game.playerNum)
				setActiveItem(data.index);
		}
		
		private function setActiveItem(itemIndex:int):void
		{
			if (_activeItem)
				_activeItem.selected = false;
				
			_activeItem = _items[itemIndex];
			
			if (_activeItem)
				_activeItem.selected = true;
		}
		//} endregion
		
		//{ region itemMove
		private function onCellPress(cell:Cell):void
		{
			var deletedItems:Array = _strategy.getDeletedItems(_activeItem, cell);
			
			var newData:ItemData = new ItemData(_activeItem.data);
			newData.row = cell.row;
			newData.col = cell.col;
			
			if (!_activeItem.isKing)
			{
				newData.isKing = _activeItem.atBottom && cell.row == 0
					|| !_activeItem.atBottom && cell.row == SIZE - 1;
			}
			
			client.sendMoveItem(newData);
			moveItem(newData);
			updateCells();
			disableItems();
			
			if (deletedItems.length > 0)
			{
				for each (var item:Item in deletedItems)
				{
					client.sendRemoveItem(item.data.index);
					removeItem(item);
				}
				
				updateCells();
				
				if (_strategy.findEnemiesForItem(_activeItem).length > 0)
				{
					setEnemiesSign([_activeItem]);
					setEnabledCells();
				}
				else
				{
					finishAction();
				}
			}
			else
			{
				finishAction();
			}
		}
		
		private function onItemMove(data:ItemData):void
		{
			Global.playSound(SndTurn);
			if (data.playerNum != game.playerNum)
				moveItem(data);
		}
		
		private function moveItem(data:ItemData):void
		{
			var item:Item = _items[data.index];
			item.setCoords(data.row, data.col);
			item.isKing = data.isKing;
			setItemPos(item);
		}
		
		private function onItemRemove(index:int):void
		{
			var item:Item = _items[index];
			if (item)
				removeItem(item);
		}
		
		private function removeItem(item:Item):void
		{
			_content.removeChild(item);
			_items[item.data.index] = null;
		}
		//} endregion
		
		//{ region view
		private function setItemPos(item:Item):void
		{
			var twean:Object = {
				x: item.data.col * CELL_SIZE + 0.5 * CELL_SIZE,
				y: item.data.row * CELL_SIZE + 0.5 * CELL_SIZE
			}
			
			new SpriteTweaner(item, twean, 10);
		}
		
		private function updateCells():void
		{
			for (var i:int = 0; i < SIZE; i++)
			{
				for (var j:int = 0; j < SIZE; j++)
				{
					var cell:Cell = Cell(_cells[i][j]);
					cell.item = null;
					cell.enabled = false;
				}
			}
			
			for each (var item:Item in _items)
			{
				if (item)
					Cell(_cells[item.row][item.col]).item = item;
			}
		}
		
		private function disableItems():void
		{
			setItemsEnabled(_strategy.getMyItems(), false);
		}
		
		private function setItemsEnabled(items:Array, value:Boolean):void
		{
			for each (var item:Item in items)
			{
				item.enabled = value;
			}
		}
		
		private function setEnemiesSign(enabledItems:Array):void
		{
			var hisItems:Array = _strategy.getHisItems();
			for each (var hisItem:Item in hisItems)
			{
				hisItem.enemySign = false;
			}
			
			for each (var item:Item in enabledItems)
			{
				var enemies:Array = _strategy.findEnemiesForItem(item);
				for each (var enemy:Item in enemies)
				{
					enemy.enemySign = true;
				}
			}
		}
		
		public function setEnabledCells():void
		{
			for (var i:int = 0; i < SIZE; i++)
			{
				for (var j:int = 0; j < SIZE; j++)
				{
					Cell(_cells[i][j]).enabled = false;
				}
			}
			
			var enabledCells:Array = _strategy.getEnabledCells(_activeItem);
			
			for each (var cell:Cell in enabledCells)
			{
				cell.enabled = true;
			}
		}
		//} endregion
	}
	
}