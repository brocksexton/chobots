package
{
	import com.kavalok.modules.ModuleBase;
	import com.kavalok.gameChopaj.Game;
	public class GameChopaj extends ModuleBase
	{
		
		override public function initialize():void
		{
			trace('--', parameters.wallScale);
			var wallScale:Number = parseFloat(parameters.wallScale);
			if (isNaN(wallScale))
				wallScale = 1.6;
				
			var game:Game = new Game(
				parameters.playerNum,
				parameters.remoteId,
				wallScale);
			game.readyEvent.addListener(readyEvent.sendEvent);
		}
	}
	
}