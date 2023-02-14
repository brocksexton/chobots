package com.kavalok.robotCombat.view
{
	import assets.combat.McWinScreen;
	
	public class WinView extends FinishViewBase
	{
		private var _content:McWinScreen = new McWinScreen();
		
		public function WinView()
		{
			super(_content);
		}
		
		override protected function get captionText():String
		{
			return bundle.messages.youWon;
		}
	}
}