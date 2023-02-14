package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.fightAction.ThrowBubbleAction;
	
	public class BubbleAction extends ThrowAction
	{
		public function BubbleAction()
		{
			super(ThrowBubbleAction);
			fightModel = WBubbleFight;
			
			_showModel = PlayerModelStay;
			_shellModels = [WBubble];
			_countTotal = 3;
			
		}
		
		override public function get id():String
		{
			return "weaponBubble";
		}
		
	}
}