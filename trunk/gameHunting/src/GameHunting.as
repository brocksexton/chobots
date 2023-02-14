package
{
	import com.kavalok.gameHunting.Game;
	import com.kavalok.Global;
	import com.kavalok.modules.LocationModule;
	
	public class GameHunting extends LocationModule
	{
		private var _game:Game;
		
		override public function initialize():void
		{
			Global.frame.visible = false;
			_game = new Game(remoteId);
			_game.closeEvent.addListener(onClose);
			addChild(_game.content);
			readyEvent.sendEvent();
		}
		
		private function onClose():void
		{
			Global.frame.visible = true;
			Global.locationManager.returnToPrevLoc();
			closeModule();
		}
		
		public function get remoteId():String
		{
			return parameters.remoteId;
		}
	}
}
