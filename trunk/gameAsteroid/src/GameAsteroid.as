package
{
	import com.kavalok.gameAsteroid.GameStage;
	import com.kavalok.gameAsteroid.McInfo;
	import com.kavalok.games.SinglePlayerModule;
	
	public class GameAsteroid extends SinglePlayerModule
	{
		public function GameAsteroid()
		{
			_gameClass = GameStage;
			_infoClass = McInfo;
		}
	}
	
}