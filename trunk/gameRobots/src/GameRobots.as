package
{
	import com.kavalok.gameRobots.GameStage;
	import com.kavalok.gameRobots.McInfo;
	import com.kavalok.games.SinglePlayerModule;
	
	public class GameRobots extends SinglePlayerModule
	{
		public function GameRobots():void
		{
			_gameClass = GameStage;
			_infoClass = McInfo;
		}
	}
}