package  
{
	import com.kavalok.gameMoney.GameStage;
	import com.kavalok.gameMoney.McInfo;
	import com.kavalok.games.SinglePlayerModule;
	
	public class GameMoney extends SinglePlayerModule
	{
		public function GameMoney()
		{
			_gameClass = GameStage;
			_infoClass = McInfo;
		}
	}
}