package com.kavalok.games
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.loaders.McLoading;
	import com.kavalok.services.GameService;
	import com.kavalok.services.UpdateScoreService;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TopScores
	{
		static private const TOP_COUNT:int = 10;
		
		private var _content:McTopScores = new McTopScores();
		private var _loading:McLoading = new McLoading();
		private var _quitHandler:Function;
		private var _replayHandler:Function;
		private var _scoreId:String;
		
		public function TopScores(scoreId:String, score:Number,
			replayHandler:Function = null, quitHandler:Function = null)
		{
			_quitHandler = quitHandler;
			_replayHandler = replayHandler;
			new ResourceScanner().apply(_content);
			
			_content.positionField.text = '';
			_content.nameField.text = '';
			_content.scoreField.text = '';
			_content.quitButton.addEventListener(MouseEvent.CLICK, onQuitClick);
			_content.replayButton.addEventListener(MouseEvent.CLICK, onReplayClick);
			_content.addChild(_loading);
			
			_scoreId = scoreId;	
			Dialogs.showDialogWindow(_content);
			new UpdateScoreService(onUpdateScore).updateScore(scoreId, score);
		}
		
		private function onUpdateScore(result:Object):void
		{
			new GameService(onGetScores).getScore(_scoreId, TOP_COUNT);
		}
		
		private function onGetScores(scores:Array):void
		{
			if (!_content)
				return;
				
			var num:int = 0;
			
			for each (var score:Object in scores)
			{
				num++;
				
				if (num == TOP_COUNT && scores.length > TOP_COUNT)
				{
					appendText(_content.positionField, '...');
					appendText(_content.nameField, '...');
					appendText(_content.scoreField, '...');
				}
				else
				{
					var isUser:Boolean = (score.name == Global.charManager.charId);
					
					appendText(_content.positionField, num, isUser);
					appendText(_content.nameField, score.name, isUser);
					appendText(_content.scoreField, score.score, isUser);
				}
			}
			
			_content.removeChild(_loading);
		}
		
		private function appendText(field:TextField, text:Object, highlight:Boolean = false):void
		{
			var line:String = text.toString();
			field.appendText(line + '\n');
			
			if (highlight)
			{
				var format:TextFormat = field.defaultTextFormat;
				format.underline = true;
				format.bold = true;
				format.italic = true;
				field.setTextFormat(format, field.length - line.length - 1, field.length);
			}
		}
		
		private function onQuitClick(e:Event):void
		{
			close();
			handle(_quitHandler);
		}
		
		private function onReplayClick(e:Event):void
		{
			close();
			handle(_replayHandler);
		}
		
		public function close():void
		{
			Dialogs.hideDialogWindow(_content);
			_content = null;
		}
		
		public function handle(handler:Function):void
		{
			if (handler != null)
				handler();
		}

	}
}