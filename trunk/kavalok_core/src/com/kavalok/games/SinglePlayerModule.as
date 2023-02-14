package com.kavalok.games
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.modules.LocationModule;
	
	import flash.utils.getQualifiedClassName;
	
	public class SinglePlayerModule extends LocationModule
	{
		protected var _gameClass:Class;
		protected var _infoClass:Class;
		protected var _game:SinglePlayerGame;
		
		public function SinglePlayerModule()
		{
			super();
		}
		
		override public function initialize():void
		{
			Global.frame.visible = false;
			createNewGame();
			showInfo();
			readyEvent.sendEvent();
		}
		
		private function showInfo():void
		{
			var dialog:DialogOkView = 
				Dialogs.showOkDialog(null, true, new _infoClass());
			dialog.ok.addListener(_game.start);
		}
		
		private function createNewGame():void
		{
			_game = new _gameClass();
			_game.closeEvent.addListener(onClose);
			_game.replayEvent.addListener(onReplay);
			_game.scoreEvent.addListener(onScore);
			_game.refresh();
			addChild(_game.content);
		}
		
		public function destroy():void
		{
			destroyCurrentGame();
		}
		
		private function onScore(score:Number):void
		{
			new TopScores(
				getQualifiedClassName(this),
				score,
				onReplay,
				onClose);
		}
		
		private function onReplay(e:Object = null):void
		{
			destroyCurrentGame();
			createNewGame();
			_game.start();
		}
		
		private function destroyCurrentGame():void
		{
			if (_game)
			{
				_game.events.clearEvents();
				removeChild(_game.content);
			}
		}
		
		private function onClose(e:Object = null):void
		{
			_game.closeEvent.removeListener(onClose);
			destroyCurrentGame();
			Global.frame.visible = true;
			closeModule();
			Global.locationManager.returnToPrevLoc();
		}

	}
}