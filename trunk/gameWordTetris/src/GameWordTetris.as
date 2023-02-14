package {
	
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.gameWordTetris.GameScreen;
	import com.kavalok.gameWordTetris.startScreen.StartScreen;
	import com.kavalok.loaders.LoadURLCommand;
	import com.kavalok.modules.LocationModule;
	
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;

	public class GameWordTetris extends LocationModule
	{
		static private const CHAR_WIDTH:int = 24;
		
		static private var _instance:GameWordTetris;
		
		private var _levels:XML;
		private var _levelNum:int = 0;
		private var _levelsCount:int;
		private var _bundle:ResourceBundle = Localiztion.getBundle('gameWordTetris');
		
		override public function initialize():void
		{
			_instance = this;
			
			loadLevels();
		}
		
		private function loadLevels():void
		{
			var url:String = URLHelper.moduleFolder("gameWordTetris") + "levels."
				+ Localiztion.locale + '.xml';
			new LoadURLCommand(url, onLevelsLoaded).execute();
		}
		
		private function onLevelsLoaded(data:Object):void
		{
			if (data)
			{
				_levels = new XML(data);
				_levelsCount = _levels.children().length();
				showStartScreen();
				//showGameScreen(0);
				
				readyEvent.sendEvent();
			}
		}
		
		public function showStartScreen():void
		{
			changeView(new StartScreen());
		}
		
		public function showGameScreen():void
		{
			var levelInfo:XML = _levels.children()[_levelNum];
			changeView(new GameScreen(levelInfo));
		}
		
		public function showHelp():void
		{
		}
		
		public function close():void
		{
			Global.locationManager.returnToPrevLoc();
			closeModule();
		}
		
		public static function get instance():GameWordTetris { return _instance; }
		
		public function get levels():XML { return _levels; }
		
		public function get levelNum():int { return _levelNum; }
		
		public function get levelsCount():int { return _levelsCount; }
		
		public function set levelNum(value:int):void
		{
			_levelNum = value;
		}
		
		public function get bundle():ResourceBundle { return _bundle; }
	}
}
