package com.kavalok.questAcademy
{
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.controls.CheckBox;
	import com.kavalok.gameplay.controls.RadioGroup;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.Arrays;
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.Strings;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import questAcademy.McLost;
	import questAcademy.McQuestion;
	import questAcademy.McWellcome;
	import questAcademy.McWin;
	
	public class NPCDialog
	{
		static private const NUM_QUESTIONS:int = 10;
		static private const NUM_CORRECT:int = 8;
		static private const NUM_ANSWERS:int = 3;
		
		private var _content:McDialog = new McDialog();
		private var _view:Sprite;
		private var _tasks:Array = [];
		private var _taskNum:int = 0;
		private var _currentTask:Task;
		private var _numCorrect:int;
		private var _currentCorrect:Boolean;
		
		public function NPCDialog()
		{
			_content.stop();
			_content.closeButton.addEventListener(MouseEvent.CLICK, close);
			_content.captionField.text = bundle.messages.caption;
		}
		
		public function execute():void
		{
			Dialogs.showDialogWindow(_content);
			showWellcome();
		}
		
		private function showWellcome(e:Event = null):void
		{
			_numCorrect = 0;
			_taskNum = 0;
			readTasks();
			
			var view:McWellcome = new McWellcome();
			view.textField.text = bundle.messages.wellcome;
			view.nextButton.addEventListener(MouseEvent.CLICK, showTask);
			
			changeView(view);
		}
		
		private function showTask(e:Event = null):void
		{
			_currentTask = _tasks[_taskNum];
			
			var view:McQuestion = new McQuestion();
			view.textField.text = _currentTask.question;
			
			view.nextButton.visible = _taskNum < NUM_QUESTIONS - 1;
			view.nextButton.addEventListener(MouseEvent.CLICK, nextTask);
			view.finishButton.visible = _taskNum == NUM_QUESTIONS - 1;
			view.finishButton.addEventListener(MouseEvent.CLICK, nextTask);
			
			GraphUtils.setBtnEnabled(view.finishButton, false);
			GraphUtils.setBtnEnabled(view.nextButton, false);
			
			var group:RadioGroup = new RadioGroup();
			group.clickEvent.addListener(onAnswerClick);
			
			for (var i:int = 0; i < NUM_ANSWERS; i++)
			{
				TextField(view['answer' + i]).text = _currentTask.answers[i];
				
				var button:CheckBox = new CheckBox(view['check' + i]);
				group.addButton(button);
			}
			
			changeView(view);
		}
		
		private function onAnswerClick(group:RadioGroup):void
		{
			_currentCorrect = (group.selectedIndex == _currentTask.correctNum);
			GraphUtils.setBtnEnabled(McQuestion(_view).finishButton, true);
			GraphUtils.setBtnEnabled(McQuestion(_view).nextButton, true);
		}
		
		private function nextTask(e:Event = null):void
		{
			_taskNum++;
			if (_currentCorrect)
				_numCorrect++;
				
			if (_taskNum < NUM_QUESTIONS)
			{
				showTask();
			}
			else
			{
				if (_numCorrect >= NUM_CORRECT)
					showWin();
				else
					showLost();
			}
		}
		
		private function showWin():void
		{
			var view:McWin = new McWin();
			view.textField.text = bundle.messages.win;
			view.okButton.addEventListener(MouseEvent.CLICK, onFinishTask);
			_content.closeButton.visible = false;
			
			if (!quest.hasItem(Quest.STUFF_ITEM1))
			{
				view.imagesClip.gotoAndStop(1);
			}
			/*else if (!quest.hasItem(Quest.STUFF_ITEM2))
			{				
				view.imagesClip.gotoAndStop(2);
			} */
			else
			{
				view.imagesClip.gotoAndStop(3);
			}
			
			
			changeView(view);
		}
		
		private function showLost():void
		{
			var view:McLost = new McLost();
			view.textField.text = bundle.messages.lost;
			view.tryAgainButton.addEventListener(MouseEvent.CLICK, showWellcome);
			
			changeView(view);
		}
		
		private function changeView(view:Sprite):void
		{
			new ResourceScanner().apply(view);
			if (_view)
				_content.removeChild(_view);
			
			_view = view;
			_view.x = _content.background.x;
			_view.y = _content.background.y;
			
			_content.addChild(_view);
		}
		
		private function readTasks():void
		{
			var text:String = bundle.messages.questions;
			text = Strings.replaceCharacters(text, ['\n'], ['|']);
			text = Strings.replaceCharacters(text, ['\r'], ['|']);
			text = Strings.replaceCharacters(text, [String.fromCharCode(13)], ['|']);
			var lines:Array = text.split('|');
			var i:int = 0;
			
			while (i < lines.length)
			{
				var task:Task = new Task();
				task.question = lines[i];
				
				for (var j:int = 0; j < NUM_ANSWERS; j++)
				{
					var answer:String = lines[i + j + 1];
					if (answer.substr(0, 1) == '#')
					{
						answer = answer.substr(1);
						task.correctNum = j;
					}
					task.answers.push(answer);
				}
				//trace(task.toString());
				_tasks.push(task);
				i += NUM_ANSWERS + 1;
			}
			
			_tasks = Arrays.randomItems(_tasks, NUM_QUESTIONS);
		}
		
		private function onFinishTask(e:MouseEvent):void
		{
			if (!quest.hasItem(Quest.STUFF_ITEM1))
			{
				quest.retriveItem(Quest.STUFF_ITEM1);
			}
			/*else if (!quest.hasItem(Quest.STUFF_ITEM2))
			{				
				quest.retriveItem(Quest.STUFF_ITEM2);
			}*/
			else 
			{
				Global.addExperience(3);
				new AddMoneyCommand(Quest.MONEY, 'questAcademy').execute();
			}
			Global.sendAchievement("ac15;","Choproff");
			close();
		}
		
		private function close(e:Event = null):void
		{
			Dialogs.hideDialogWindow(_content);
		}
		
		protected function get quest():Quest
		{
			 return Quest.instance;
		}
		
		protected function get bundle():ResourceBundle
		{
			return Quest.instance.bundle
		}
		
		
	}
}