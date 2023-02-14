package com.kavalok.gameWordTetris.startScreen
{
	import com.kavalok.gameplay.controls.IFlashView;
	import com.kavalok.gameWordTetris.Controller;
	import com.kavalok.gameWordTetris.McStartScreen;
	import com.kavalok.utils.ResourceScanner;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class StartScreen extends Controller implements IFlashView
	{
		private var _content:McStartScreen = new McStartScreen();
		
		private var _levelsList:LevelsList;
		
		public function StartScreen()
		{
			initContent();
		}
		
		private function initContent():void
		{
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_content.playButton.addEventListener(MouseEvent.CLICK, onPlayClick);
			_content.helpButton.addEventListener(MouseEvent.CLICK, onHelpClick);
			
			_levelsList = new LevelsList(_content.levelList, module.levels);
			_levelsList.levelNum = module.levelNum;
			
			new ResourceScanner().apply(_content);
		}
		
		private function onPlayClick(e:MouseEvent):void
		{
			module.levelNum = _levelsList.levelNum;
			module.showGameScreen();
		}
		
		private function onHelpClick(e:MouseEvent):void
		{
			module.showHelp();
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			module.close();
		}
		
		public function get content():Sprite { return _content; }
	}
	
}