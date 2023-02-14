package
{
	import com.kavalok.Global;
	import com.kavalok.constants.Locations;
	import com.kavalok.gameSpiceRacing.Config;
	import com.kavalok.gameSpiceRacing.GameStage;
	import com.kavalok.modules.LocationModule;
	
	public class GameSpaceRacing extends LocationModule
	{
		private var _game:GameStage;
		private var _remoteId:String;
		
		override public function initialize():void
		{
			_remoteId = parameters.remoteId;
			
			Global.frame.visible = false;
			
			if (!_remoteId)
				_remoteId = Config.DEBUG_REMOTE_ID;
			
			_game = new GameStage(_remoteId);
			_game.closeEvent.addListener(closeGame);
			
			addChild(_game.content);
			
			readyEvent.sendEvent();
		}
		
		private function closeGame(dummy:Object = null):void
		{
			_game.destroy();
			Global.frame.visible = true;
			Global.locationManager.returnToPrevLoc();
			closeModule();
		}
		
	}
	
}