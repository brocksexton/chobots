package com.kavalok.robotCombat.view
{
	import assets.combat.McCombatScreen;
	import assets.combat.McControls;
	
	import com.kavalok.Global;
	import com.kavalok.dto.robot.CombatActionTO;
	import com.kavalok.gameplay.controls.ProgressBar;
	import com.kavalok.robotCombat.Combat;
	import com.kavalok.robotCombat.CombatSounds;
	import com.kavalok.robotCombat.commands.QuitCommand;
	import com.kavalok.robots.RobotModel;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.TypeRequirement;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class MainView extends ModuleViewBase
	{
		static private var _instance:MainView;
		static public function get instance():MainView
		{
			 return _instance;
		}
		
		private var _content:McCombatScreen;
		private var _controls:McControls;
		
		private var _commandPanel:ActionView;
		
		private var _myView:PlayerView;
		private var _opponentView:PlayerView;
		private var _timer:Timer;
		private var _timerHighLightFilters:Array = [new GlowFilter(0xFF0000, 1, 4, 4, 5)];
		
		public function MainView()
		{
			_instance = this;
			initTimer();
			initContent();
			initView();
			initStars();
			combat.dataReadyEvent.addListener(onDataReady);
			combat.changeEvent.addListener(onDataChanged);
			waitingVisible = false;
		}
		
		private function initTimer():void
		{
			_timer = new Timer(1000, Combat.TIME_LIMIT);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
		private function initContent():void
		{
			_content = new McCombatScreen();
			_controls = _content.controls;
			_controls.visible = false;
			_content.stars.mouseEnabled = false;
			_content.stars.mouseChildren = false;
			GraphUtils.optimizeBackground(_content.background);
			
			initTextField(_controls.timeCaption);
			initTextField(_controls.timeField);
			initTextField(_content.waitingCaption);
			initTextField(_content.actionCaption);
			
			bundle.registerTextField(_controls.timeCaption, 'timeLeft');
			bundle.registerTextField(_content.waitingCaption, 'waitingForOpponent');
			bundle.registerTextField(_content.actionCaption, 'waitingForOpponent');
			
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		private function initView():void
		{
			_commandPanel = new ActionView(_content.commandPanel);
			_commandPanel.actionEvent.addListener(onActionReady);
			_commandPanel.hide();
			
			_myView = new PlayerView(combat.myPlayer);
			_myView.charView = new CharView(_controls.myModel, _controls.myName);
			_myView.artifactView = new ArtifactsView(_controls.myItems);
			_myView.robotView = new RobotView(
				_content.myRobot, _controls.myLevel, _controls.mytEnergyField);
			_myView.energyBar = new ProgressBar(_controls.myEnergy);
			_myView.setTextPosition(_content.myTextCoords);
			
			_opponentView = new PlayerView(combat.opponentPlayer);
			_opponentView.charView = new CharView(_controls.opponentModel, _controls.opponentName);
			_opponentView.artifactView = new ArtifactsView(_controls.opponentItems);
			_opponentView.robotView = new RobotView(
				_content.opponentRobot, _controls.opponentLevel, _controls.opponentEnergyField);
			_opponentView.energyBar = new ProgressBar(_controls.opponentEnergy);
			_opponentView.setTextPosition(_content.opponentTextCoords);
		}
		
		
		private function onDataReady():void
		{
			_controls.visible = true;
			_content.closeButton.visible = false;
			GraphUtils.detachFromDisplay(_content.waitingCaption);
			waitingVisible = false;
			
			_commandPanel.setItems(combat.myPlayer.robot.specialItems);
			_myView.applyData();
			_opponentView.applyData();
		}
		
		private function onDataChanged():void
		{
			_myView.refresh();
			_opponentView.refresh();
		}
		
		public function startRound():void
		{
			_timer.reset();
			_timer.start();
			
			_controls.timeField.text = String(Combat.TIME_LIMIT);
			_controls.timeField.filters = [];
			_commandPanel.show();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			var seconds:int = Combat.TIME_LIMIT - Timer(e.target).currentCount
			
			if (seconds == 3)
			{
				Global.playSound(CombatSounds.TIMER);
				_controls.timeField.filters = _timerHighLightFilters;
			}
			_controls.timeField.text = String(seconds);
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			sendAction(new CombatActionTO());
		}
		
		private function onActionReady():void
		{
			sendAction(_commandPanel.action);
		}
		
		private function sendAction(action:CombatActionTO):void
		{
			_timer.stop();
			_controls.timeField.text = '';
			_commandPanel.enabled = false;
			_commandPanel.hide();
			waitingVisible = true;
			combat.client.sendAction(action);
		}
		
		public function set waitingVisible(value:Boolean):void
		{
			_content.actionCaption.visible = value;
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			new QuitCommand().execute();
		}
		
		private function initStars():void
		{
			var stars:Array = GraphUtils.getAllChildren(_content.stars,
				new TypeRequirement(MovieClip), false);
				
			for each (var star:MovieClip in stars)
			{
				star.gotoAndPlay(1 + int(Math.random() * star.totalFrames));
			}
		}
		
		public function getRobotModel(userId:int):RobotModel
		{
			return getPlayerView(userId).robotView.model;
		}
		
		public function getTextPosition(userId:int):Point
		{
			return getPlayerView(userId).textPosition;
		}
		
		public function getPlayerView(userId:int):PlayerView
		{
			return (userId == _myView.player.userId)
				?_myView
				: _opponentView;
		}
		
		public function attachAnimation(clip:MovieClip):void
		{
			GraphUtils.attachAfter(clip, _controls);
		}
		
		public function get content():Sprite { return _content; }
		
	}
}