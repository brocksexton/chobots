package com.kavalok.gameChess.actions
{
	import com.kavalok.gameChess.Cell;
	import com.kavalok.gameChess.data.ItemData;
	import com.kavalok.gameChess.Item;
	
	public class ForcePawnHitAction extends ActionBase
	{
		private var _removedItem:Item;
		private var _removedItemCell:Cell;
		
		override public function execute():void
		{
			_removedItem = game.items[client.forcePawnData.id];
			_removedItemCell = game.getCellByItem(_removedItem);
			move(sourceCell, targetCell);
			_removedItemCell.item = null;
			game.items[_removedItem.id] = null;
		}
		
		override public function undo():void
		{
			move(targetCell, sourceCell);
			_removedItemCell.item = _removedItem;
			game.items[_removedItem.id] = _removedItem;
		}
		
		override public function sendCommands():void
		{
			client.sendMoveItem(targetCell.item.data);
			client.sendRemoveItem(_removedItem.id);
		}
	}
	
}