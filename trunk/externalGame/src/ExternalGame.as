package {
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.games.TopScores;
	import com.kavalok.loaders.SafeLoader;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.modules.LocationModule;
	import com.kavalok.utils.GraphUtils;
	
	import externalGame.McScreen;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	public class ExternalGame extends LocationModule
	{
		private var _loader:SafeLoader;
		private var _content:McScreen;
		private var _game:Sprite;
		private var _score:int = 0;
		private var _cAmnt:int = 0;
		
		public function ExternalGame()
		{
		}
		
		override public function initialize():void
		{
			Global.frame.visible = false;
			Global.music.stop();
			createContent();
			readyEvent.sendEvent();
			loadGame();
		}
		
		private function loadGame():void
		{
			var url:String = URLHelper.resourceURL(fileName, 'externalGame');
			_loader = new SafeLoader();
			_loader.completeEvent.addListener(onLoadComplete);
			_loader.load(new URLRequest(url));
			_loader.x = _content.gamePosition.x;
			_loader.y = _content.gamePosition.y;
			_content.addChild(_loader);
			GraphUtils.bringToFront(_content.gameBorder);
		}
		
		private function onLoadComplete():void
		{
			_game = Sprite(_loader.content);
			_game['onMoney'] = onMoney;
			_game['onScore'] = onScore;
		}
		
		private function onMoney(money:int):void
		{
			new AddMoneyCommand(money, 'gameRacer', true).execute();
			_cAmnt += 0.5;
			if(_cAmnt == 2){
			Global.addExperience(1);
			_cAmnt = 0;
			}
		}
		
		private function onScore(score:int):void
		{
			_score = score;
		}
		
		private function createContent():void
		{
			_content = new McScreen();
			_content.gamePosition.visible = false;
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			
			var bg:Bitmap = GraphUtils.convertToBitmap(_content.background,
				new Rectangle(0, 0, KavalokConstants.SCREEN_WIDTH, KavalokConstants.SCREEN_HEIGHT));
			GraphUtils.detachFromDisplay(_content.background);
			_content.addChildAt(bg, 0);
			
			addChild(_content);
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			if (_score > 0)
				new TopScores(fileName, _score, null, closeModule);
			else
				closeModule();
		}
		
		override public function closeModule():void
		{
			if (_loader.content)
				_loader.cancelLoading();
			GraphUtils.detachFromDisplay(_loader);
			_loader = null;
			super.closeModule();
			Global.frame.visible = true;
			Global.locationManager.returnToPrevLoc();
		}
		
		public function get fileName():String
		{
			 var fileName:String = parameters.fileName;
			 if (Localiztion.locale == KavalokConstants.LOCALE_DE)
			 	fileName += 'DE';
			 return fileName;
		}
	}
}
