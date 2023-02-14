package com.kavalok.gameChess.actions
{
	import com.kavalok.gameChess.data.ItemData;
	
	public class MoveAction extends ActionBase
	{
		override public function execute():void
		{
			move(sourceCell, targetCell);
		}
		
		override public function undo():void
		{
			move(targetCell, sourceCell);
		}
		
		override public function sendCommands():void
		{
			checkTransform();
			client.sendMoveItem(targetCell.item.data);
		}
	}
	
}