package com.kavalok.gameChess.actions
{
	import com.kavalok.gameChess.data.ItemData;
	
	public class ForcePawnMoveAction extends MoveAction
	{
		override public function sendCommands():void
		{
			super.sendCommands();
			client.sendForcePawn(targetCell.item.data);
		}
	}
	
}