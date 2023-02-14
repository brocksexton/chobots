package com.kavalok.gameSweetBattle.fightAction
{
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.Global;
	import com.kavalok.utils.EventManager;
	
	public class FightActionBase implements IFightAction
	{
		protected var player : Player;
		protected var data : Object;
		protected var stage : GameStage;
		
		private var _safeSoundTime:Number = 0;
		
		public function FightActionBase(stage : GameStage, player : Player, data : Object)
		{
			this.player = player;
			this.data = data;
			this.stage = stage;
		}

		public function execute():void
		{
		}
		
		protected function playSoundSafe(soundClass:Class, minInterval:int = 1000):void
		{
			var curTime:Number = new Date().time;
			
			if (curTime - _safeSoundTime >= minInterval)
			{
				_safeSoundTime = curTime;
				Global.playSound(soundClass);
			}
		}
		
	}
}