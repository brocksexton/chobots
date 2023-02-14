package com.kavalok.gameChess.actions
{
	import com.kavalok.gameChess.Cell;
	import com.kavalok.gameChess.Controller;
	import com.kavalok.gameChess.Item;
	
	public class HitAction extends ActionBase
	{
		private var _removedItem:Item;
		
		override public function execute():void
		{
			_removedItem = targetCell.item;
			move(sourceCell, targetCell);
			game.items[_removedItem.id] = null;
		}
		
		override public function undo():void
		{
			move(targetCell, sourceCell);
			targetCell.item = _removedItem;
			game.items[_removedItem.id] = _removedItem;
		}
		
		override public function sendCommands():void
		{
			checkTransform();
			client.sendMoveItem(targetCell.item.data);
			client.sendRemoveItem(_removedItem.id);
		}
	}
	
}