package com.kavalok.gameWordTetris
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.controls.IFlashView;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.Sequence;
	import com.kavalok.utils.Strings;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GameScreen extends Controller implements IFlashView
	{
		private static const WORDS_FORMAT : String = "<p align='left'><font color='#0000ff'><b>{0}</b></font> {1}</p>";
		
		private var _content:McGameScreen = new McGameScreen();
		private var _wordsField:WordsField = new WordsField(_content.wordsClip);
		private var _phraseField:PhaseField = new PhaseField(_content.phraseClip);
		private var _nextLevelCount:int;
		
		private var _phrases:Array = [];
		private var _usedPhrases:Array = [];
		private var _timerCounter:int = 0;
		
		public function GameScreen(levelInfo:XML)
		{
			initContent();
			initWordsField(levelInfo.word);
			createWords(levelInfo.word);
			readPhrases(levelInfo.phrase);
			
			_phraseField.phraseEvent.addListener(refresh);
			
			_nextLevelCount = parseInt(levelInfo.@nextLevel);
			
			refresh();
			
			_content.addEventListener(Event.ENTER_FRAME, updateTimer);
		}
		
		private function updateTimer(e:Event):void
		{
			if (!_content.stage)
			{
				stopTimer();
				return;
			}
			
			_timerCounter++;
			var totalTime:int = Config.LEVEL_TIME * Global.stage.frameRate
			_content.timerBar.line.scaleX = _timerCounter / totalTime;
			
			if (_timerCounter >= totalTime)
			{
				stopTimer();
				var dialog:DialogOkView = Dialogs.showOkDialog(module.bundle.messages.timeOut);
				dialog.ok.addListener(module.showStartScreen);
			}
		}
		
		private function stopTimer():void
		{
			_content.removeEventListener(Event.ENTER_FRAME, updateTimer);
		}
		
		private function refresh():void
		{
			var phrase:String = _phraseField.getPhrase();
			
			GraphUtils.setBtnEnabled(_content.submitButton, phrase.length > 0)
		}
		
		private function initContent():void
		{
			_content.phrasesField.text = '';
			_content.nextButton.visible = false;
			
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_content.helpButton.addEventListener(MouseEvent.CLICK, onHelpClick);
			_content.backButton.addEventListener(MouseEvent.CLICK, onBackClick);
			_content.submitButton.addEventListener(MouseEvent.CLICK, onSubmitClick);
			_content.nextButton.addEventListener(MouseEvent.CLICK, onNextClick);
			
			new ResourceScanner().apply(_content);
		}
		
		private function onNextClick(e:MouseEvent):void
		{
			if (module.levelNum < module.levelsCount - 1)
				module.levelNum++;
			else
				Dialogs.showOkDialog(module.bundle.messages.noMoreLevels);
			
			module.showStartScreen();
		}
		
		private function onSubmitClick(e:MouseEvent):void
		{
			var phrase:String = _phraseField.getPhrase();
			
			if (_phrases.indexOf(phrase.toLowerCase()) >= 0)
			{
				if (_usedPhrases.indexOf(phrase.toLowerCase()) == -1)
					addPhrase(phrase);
					
				refresh();
			}
			else
			{
			}
		}
		
		private function addPhrase(phrase:String):void
		{
			_usedPhrases.push(phrase);
			_content.phrasesField.appendText(phrase + '\n');
			_phraseField.clear();
			
			if (_usedPhrases.length == _nextLevelCount)
				showNextButton();
		}
		
		private function showNextButton():void
		{
			var btn:DisplayObject = _content.nextButton;
			
			btn.visible = true;
			btn.scaleX = btn.scaleY = 0.2;
			
			var props:Array =
			[
				{scaleX: 1.2, scaleY:1.2},
				{scaleX: 1.0, scaleY:1.0},
			]
			
			var sequence:Sequence = new Sequence(btn, props, 5);
		}
		
		private function createWords(list:XMLList):void
		{
			_content.wordsField.text = '';
			
			for each (var text:XML in list)
			{
				var parts:Array = String(text).split('-');
				
				var htmlText:String = Strings.substitute(
					WORDS_FORMAT,
					parts[0],
					'-' + parts[1]
				);
				
				_content.wordsField.htmlText += htmlText;
			}
		}
		
		private function readPhrases(list:XMLList):void
		{
			for each (var text:XML in list)
			{
				var phrase:String = String(text);
				while (phrase.indexOf('  ') >= 0)
					phrase.replace('  ', ' ');
				
				_phrases.push(phrase.toLowerCase());
			}
		}
		
		private function initWordsField(list:XMLList):void
		{
			for each (var text:XML in list)
			{
				var pair:Array = String(text).split('-');
				var word:String = Strings.trim(String(pair[0]));
				
				addItem(word);
				
				_content.wordsField.appendText(text + '\n');
			}
		}
		
		private function addItem(word:String):void
		{
			var item:WordBox = new WordBox(word, _content.getBounds(content));
			item.startDragEvent.addListener(onItemPress);
			item.finishDragEvent.addListener(onItemRelease);
				
			_wordsField.addItem(item);
		}
		
		private function onItemPress(item:WordBox):void
		{
			if (_wordsField.content.contains(item))
				addItem(item.word);
			
			GraphUtils.changeParent(item, _content);
			_phraseField.applyPlacement();
		}
		
		private function onItemRelease(item:WordBox):void
		{
			if (item.hitTestObject(_phraseField.content) && _phraseField.accept(item.word))
				_phraseField.addItem(item);
			else
				item.destroy();
		}
		
		private function onHelpClick(e:MouseEvent):void
		{
			module.showHelp();
		}
		
		private function onBackClick(e:MouseEvent):void
		{
			module.showStartScreen();
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			module.close();
		}
		
		public function get content():Sprite { return _content; }
		
	}
	
}