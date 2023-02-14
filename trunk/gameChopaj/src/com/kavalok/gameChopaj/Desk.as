package com.kavalok.gameChopaj
{
	import com.kavalok.gameChopaj.Controller;
	import com.kavalok.gameChopaj.data.ItemData;
	import com.kavalok.gameChopaj.Item;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	import gameChopaj.McCell;
	import gameChopaj.McCellsClip;
	
	import flash.display.Sprite;
	
	import gameChopaj.McGameWindow;
	
	public class Desk extends Controller
	{
		static public const SIZE:int = 8;
		static public const CELL_SIZE:int = 32;
		
		static public function getX(col:int):Number
		{
			return (col + 0.5) * CELL_SIZE;
		}
		
		static public function getY(row:int):Number
		{
			return (row + 0.5) * CELL_SIZE;
		}
		
		private var _content:McCellsClip;
		private var _itemsContainer:Sprite = new Sprite();
		private var _activeItem:Item;
		private var _rotated:Boolean;
		
		public function Desk(wallScale:Number)
		{
			_rotated = (game.playerNum == 1);
			_content = game.content.deskClip.cellsClip;
			
			_content.leftBorder.scaleX = wallScale;
			_content.rightBorder.scaleX = wallScale;
			_content.topBorder.scaleX = wallScale;
			_content.bottomBorder.scaleX = wallScale;
			
			createCells();
			
			_content.addChild(_itemsContainer);
			if (_rotated)
			{
				_content.rotation = 180;
				_content.x = 8 * CELL_SIZE;
				_content.y = 8 * CELL_SIZE;
			}
		}
		
		private function createCells():void
		{
			for (var i:int = 0; i < SIZE; i++)
			{
				for (var j:int = 0; j < SIZE; j++)
				{
					var cell:McCell = new McCell();
					cell.x = j * CELL_SIZE;
					cell.y = i * CELL_SIZE;
					
					if ((i + j) % 2 == 1)
						cell.gotoAndStop(1);
					else
						cell.gotoAndStop(2);
					
					_content.addChild(cell);
				}
			}
		}
		
		public function refreshItems():void
		{
			GraphUtils.removeChildren(_itemsContainer);
			
			var items:Array = game.getAllItems();
			for each (var item:Item in items)
			{
				_itemsContainer.addChild(item);
			}
		}
		
		public function setActiveItem(item:Item):void
		{
			if (_activeItem)
				_activeItem.selected = false;
				
			_activeItem = item;
			
			if (_activeItem)
				_activeItem.selected = true;
		}
		
		private function setItemsEnabled(items:Array, value:Boolean):void
		{
			for each (var item:Item in items)
			{
				item.enabled = value;
			}
		}
		
		public function get content():Sprite { return _content; }
		//} endregion
	}
	
}