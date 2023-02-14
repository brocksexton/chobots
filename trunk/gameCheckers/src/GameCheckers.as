package
{
	import com.kavalok.char.Char;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.Global;
	import com.kavalok.gameCheckers.GameClient;
	import com.kavalok.gameCheckers.view.MainView;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.modules.ModuleBase;
	import com.kavalok.modules.ModuleManager;
	import com.kavalok.services.CompetitionService;
	import com.kavalok.utils.GraphUtils;
	
	public class GameCheckers extends ModuleBase
	{
		static public const MONEY_WIN:int = 100;
		static public const MONEY_LOST:int = 10;
		
		static private var _instance:GameCheckers;
		
		private var _mainView:MainView;
		private var _client:GameClient = new GameClient();
		
		override public function initialize():void
		{
			_instance = this;
			_mainView = new MainView();
			_mainView.closeEvent.addListener(onCloseClick);
			_client.connectEvent.addListener(onClientConnect);
			_client.connect(remoteId);
			_client.victoryEvent.addListener(onVictory);
			
			Global.borderContainer.addChild(_mainView.content);
			Global.tableGameCloseEvent.addListener(onTableDispose);
			GraphUtils.alignCenter(_mainView.content, KavalokConstants.SCREEN_RECT);
		}
		
		private function onClientConnect():void
		{
			readyEvent.sendEvent();
		}
		
		private function onCloseClick():void
		{
			if (_client.connected)
				Global.tableGameCloseEvent.sendEvent(remoteId);
			else
				GraphUtils.detachFromDisplay(_mainView.content);
		}
		
		private function onTableDispose(remoteId:String):void
		{
			if (remoteId != remoteId)
				return;
			
			Global.tableGameCloseEvent.removeListener(onTableDispose);
			
			if (client.connected)
			{
				_client.disconnect();
				GraphUtils.detachFromDisplay(_mainView.content);
			}
		}
		
		private function onVictory(winner:int):void
		{
			if (winner == playerNum)
			{
				new AddMoneyCommand(MONEY_WIN, "checkers").execute();
				
				var looser:String = String(Char(_client.players[1 - winner]).userId);
				new CompetitionService().addCompetitorResult(
					looser, Competitions.CHECKERS, 1);
			}
			else
			{
				new AddMoneyCommand(MONEY_LOST, "checkers").execute();
			}
				
			_client.disconnect();
			Global.tableGameCloseEvent.sendEvent(remoteId);
		}
		
		public function get playerNum():int
		{
			return parameters.playerNum;
		}
		
		public function get remoteId():String
		{
			return parameters.remoteId;
		}
		
		static public function get instance():GameCheckers { return _instance; }
		
		public function get client():GameClient { return _client; }
		
	}
	
}