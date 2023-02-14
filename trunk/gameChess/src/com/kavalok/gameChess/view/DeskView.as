package com.kavalok.gameChess.view
{
	import com.kavalok.gameChess.Cell;
	import com.kavalok.gameChess.Controller;
	import com.kavalok.gameChess.Item;
	import com.kavalok.struct.Array2D;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.Sprite;
	
	public class DeskView extends Controller
	{
		static public const CELL_SIZE:int = 32;
		static public const POS_Y:Number = 0.9;
		
		private var _cells:Array2D = game.cells;
		private var _items:Array = game.items;
		
		private var _content:Sprite = new Sprite();
		private var _rotated:Boolean = (game.playerNum == 1);
		
		public function DeskView()
		{
			_rotated = (game.playerNum == 1);
			
			attachCells();
			game.content.deskClip.addChild(_content);
			
			//DEBUG
			//_rotated = false;
			if (_rotated)
			{
				_content.rotation = 180;
				_content.x = _content.x + _content.width;
				_content.y = _content.y + _content.height;
			}
		}
		
		//{ region cell creation
		private function attachCells():void
		{
			var cells:Array = _cells.getItems();
			
			for each (var cell:Cell in cells)
			{
				_content.addChild(cell);
				cell.x = cell.col * CELL_SIZE;
				cell.y = cell.row * CELL_SIZE;
			}
		}
		
		public function addItem(item:Item):void
		{
			_content.addChild(item);
			item.rotation = _content.rotation;
			item.x = (item.col + 0.5) * CELL_SIZE;
			item.y = (item.row < 4 ? 3 : 4) * CELL_SIZE
			setItemPos(item);
			updateCells();
		}
		
		public function removeItem(index:int):void
		{
			for (var i:int = 0; i < _content.numChildren; i++)
			{
				var item:Item = _content.getChildAt(i) as Item;
				if (item && item.id == index)
				{
					GraphUtils.detachFromDisplay(item);
					break;
				}
			}
			updateCells();
		}
		
		public function setItemPos(item:Item):void
		{
			var ky:Number = _rotated ? 1 - POS_Y : POS_Y;
			
			var twean:Object = {
				x: (item.col + 0.5) * CELL_SIZE,
				y: (item.row + ky) * CELL_SIZE
			}
			
			new SpriteTweaner(item, twean, 10);
			updateCells();
		}
		
		public function set itemsEnabled(value:Boolean):void
		{
			for each (var item:Item in _items)
			{
				if (item)
					item.enabled = value;
			}
		}
		
		public function set enabledCells(value:Array):void
		{
			var cells:Array = _cells.getItems();
			var cell:Cell;
			
			for each (cell in cells)
			{
				cell.enabled = false;
			}
			
			for each (cell in value)
			{
				cell.enabled = true;
			}
		}
		
		public function setAttackers(attackers:Array):void
		{
			var items:Array = game.getHisItems();
			for each (var item:Item in items)
			{
				item.warning = false;
			}
			for each (item in attackers)
			{
				item.warning = true;
			}
		}
		
		public function updateCells():void
		{
			var cells:Array = _cells.getItems();
			
			for each (var cell:Cell in cells)
			{
				cell.item = null;
			}
			
			for each (var item:Item in _items)
			{
				if (item)
					Cell(_cells.getItem(item.row, item.col)).item = item;
			}
			
			// apply ZOrder
			/*for each (cell in cells)
			{
				item = cell.item;
				
				if (item)
				{
					if (_rotated)
						GraphUtils.sendToBack(item);
					else
						GraphUtils.bringToFront(item);
				}
			}*/
		}
		
	}
	
}