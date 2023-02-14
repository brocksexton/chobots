package
{
	import com.kavalok.gameCrab.GameStage;
	import com.kavalok.gameCrab.McInfo;
	import com.kavalok.games.SinglePlayerModule;
	
	public class GameCrab extends SinglePlayerModule
	{
		public function GameCrab()
		{
			_gameClass = GameStage;
			_infoClass = McInfo;
		}
	}
	
}