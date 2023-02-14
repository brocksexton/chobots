package com.kavalok.gameChess.actions
{
	import com.kavalok.gameChess.Cell;
	
	public class CastlingAction extends ActionBase
	{
		private var _rookSourceCell:Cell;
		private var _rookTargetCell:Cell;
		
		override public function execute():void
		{
			if (sourceCell.col > targetCell.col)
			{
				_rookSourceCell = game.getCell(sourceCell.row, 0);
				_rookTargetCell = game.getCell(sourceCell.row, sourceCell.col - 1);
			}
			else
			{
				_rookSourceCell = game.getCell(sourceCell.row, 7);
				_rookTargetCell = game.getCell(sourceCell.row, sourceCell.col + 1);
			}
			
			move(sourceCell, targetCell);
			move(_rookSourceCell, _rookTargetCell);
		}
		
		override public function undo():void
		{
			move(targetCell, sourceCell);
			move(_rookTargetCell, _rookSourceCell);
		}
		
		override public function sendCommands():void
		{
			client.sendMoveItem(targetCell.item.data);
			client.sendMoveItem(_rookTargetCell.item.data);
		}
	}
	
}