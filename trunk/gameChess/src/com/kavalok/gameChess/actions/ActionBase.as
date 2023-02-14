package com.kavalok.gameChess.actions
{
	import com.kavalok.gameChess.Cell;
	import com.kavalok.gameChess.Chess;
	import com.kavalok.gameChess.Controller;
	import com.kavalok.gameChess.Item;
	
	public class ActionBase extends Controller
	{
		public var targetCell:Cell;
		public var sourceCell:Cell;
		
		public function ActionBase()
		{
		}
		
		public function execute():void {}
		
		public function undo():void {}
		
		public function sendCommands():void {}
		
		protected function move(cell1:Cell, cell2:Cell):void
		{
			var item:Item = cell1.item;
			item.data.row = cell2.row;
			item.data.col = cell2.col;
			cell2.item = item;
			cell1.item = null;
		}
		
		protected function checkTransform():void
		{
			if (targetCell.item.type == Chess.PAWN &&
				(targetCell.row == 0 || targetCell.row == 7))
			{
				targetCell.item.data.type = Chess.QUEEN;
			}
		}
		
		
	}
	
}