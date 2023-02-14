package
{
	import com.kavalok.gameChoboard.GameStage;
	import com.kavalok.gameChoboard.McInfo;
	import com.kavalok.games.SinglePlayerModule;
	
	public class GameChoboard extends SinglePlayerModule
	{
		public function GameChoboard()
		{
			_gameClass = GameStage;
			_infoClass = McInfo
		}
	}
}