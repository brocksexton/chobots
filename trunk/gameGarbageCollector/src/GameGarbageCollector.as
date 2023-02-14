package {
	import com.kavalok.Global;
	import com.kavalok.constants.Locations;
	import com.kavalok.gameGarbageCollector.GameStage;
	import com.kavalok.gameGarbageCollector.Particle;
	import com.kavalok.modules.ModuleBase;
	
	import flash.events.Event;

	public class GameGarbageCollector extends ModuleBase
	{
		private var gameStage : GameStage;
		
		public function GameGarbageCollector()
		{
			super();
		}
		
		override public function initialize():void
		{
			if (parameters.remoteId == null)
				parameters.remoteId = 'gameGarbageCollector';

			gameStage = new GameStage(parameters.remoteId, parameters.team);
			Global.locationManager.changeLocation(gameStage);
			readyEvent.sendEvent();
		}
	}
}
