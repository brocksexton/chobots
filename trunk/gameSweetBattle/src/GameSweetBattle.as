package
{
	import com.kavalok.Global;
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.modules.LocationModule;
	import com.kavalok.utils.EventManager;
	
	import flash.events.Event;
	
	public class GameSweetBattle extends LocationModule
	{
		public static const ID:String = "gameSweetBattle";
		public static const MIN_PLAYERS:int = 1; // used in debug mode
		
		static public var eventManager:EventManager;
		
		private var _gameStage:GameStage;
		private var _remoteId:String;
		
		override public function initialize():void
		{
			_remoteId = parameters.remoteId;
			
			if (_remoteId == null)
				_remoteId = ID;
				
			
			GameSweetBattle.eventManager = this.eventManager;
			createStage();
			readyEvent.sendEvent();
		}
		
		private function createStage():void
		{
			var lands : Array = parameters.lands.split(",");
			_gameStage = new GameStage(_remoteId, 0, this, lands);
			addChild(_gameStage.content);
			
			_gameStage.replayEvent.setListener(replayGame);
			_gameStage.quitEvent.setListener(quitGame);
		}
		
		private function replayGame():void
		{
			removeChild(_gameStage.content)
			eventManager.clearEvents();
			createStage();
		}
		
		private function quitGame(e:Event = null):void
		{
			_gameStage.disconnect();
			closeModule();
			Global.locationManager.returnToPrevLoc();
		}
		
	}
	
}