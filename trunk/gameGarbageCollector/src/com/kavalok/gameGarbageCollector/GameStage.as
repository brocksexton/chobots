package com.kavalok.gameGarbageCollector
{
	import com.kavalok.Global;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.constants.Modules;
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.DialogView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.Music;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.games.ReadyClient;
	import com.kavalok.games.garbageCollector.Background;
	import com.kavalok.garbageCollector.RulesDialog;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.location.LocationBase;
	import com.kavalok.services.CompetitionService;
	import com.kavalok.utils.Strings;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	public class GameStage extends LocationBase 
	{
		private static var resourceBundle : ResourceBundle = Localiztion.getBundle(Modules.GARBAGE_COLLECTOR);
		private static const MONEY_FOR_COLLISION : Number = 1;
		private static const WIN_MONEY : Number = 100;
		private static const LOSE_MONEY : Number = 10;
		private static const WAIT_TIME : Number = 5000;
		private static const MAX_SCORE : Number = 30;
		private static const QUANTITY : Number = 0.7 / 6;
		private static const SCORE_PREFIX : String = "score";
		
		private var _particlesManager : ParticlesManager;
		private var _weaponEntry : WeaponEntryPoint;
		private var _waitingDialog: DialogView;
		private var _hasToExit: Boolean;
		
		private var _state : Object;
		private var _team : uint;
		
		public function GameStage(remoteObjectId : String, team : uint)
		{
			super(remoteObjectId);
			shadowEnabled = false;
			_team = team;
			_charModelsFactory = new ModelsFactory();
			var background : Background = new Background();
			setContent(background);
			background.bonusText.visible = false;
			background.btnClose.addEventListener(MouseEvent.MOUSE_DOWN, onExitClick);
			_weaponEntry = new WeaponEntryPoint(remoteObjectId, this);
			addPoint(_weaponEntry);
		}
		
		override protected function get musicList():Array
		{
			return Music.MISSION;
		}
		
		override public function get id():String
		{
			return "gameGarbageCollector";
		}
		
		override public function charConnect(charId:String):void
		{
			if(states == null && _state != null)
			{ 
				_state[getCharStateId(charId)] = {}; 
			}
			else
			{
				super.charConnect(charId);
			}
		}
		
		override public function charDisconnect(charId:String):void
		{
			if(states == null && _state != null)
			{ 
				delete _state[getCharStateId(charId)]; 
			}
			else
			{
				super.charDisconnect(charId);
			}
			if(!_hasToExit)
			{
				refreshCharsCount();
			}
		}
		
		override public function restoreState(state:Object):void
		{
			//super.restoreState(state);
			_state = state == null ? new Object() : state;
			var rules : RulesDialog = new RulesDialog();
			var dialog : DialogOkView = Dialogs.showOkDialog(null, true, rules);
			resourceBundle.registerTextField(rules.textField, "rules");
			resourceBundle.registerTextField(rules.bonusTextField, "bonusRules");

			var quantity : Number = remote.connectedChars.length < 3 ? QUANTITY * 3 : QUANTITY;
			_particlesManager = new ParticlesManager(Background(content).weaponTarget, remoteId, quantity);
			_particlesManager.bonusTime.addListener(onBonusTime);
			_particlesManager.collision.addListener(onCollision);
			_weaponEntry.particlesManager = _particlesManager;
			
			
			dialog.ok.addListener(onRulesOk);
		}
		
		
		 
		public function rIncreaseScore(team : uint) : void
		{
			var field : TextField = getTeamScore(team);
			field.text = String(uint(field.text) + 1);
			if(Number(field.text) == MAX_SCORE)
			{
				var message : String = team == _team ? resourceBundle.messages.winText : resourceBundle.messages.loseText;
				var money : Number = team == _team ? WIN_MONEY : LOSE_MONEY;
				new AddMoneyCommand(money, Competitions.GARBAGE_COLLECTOR, true).execute();
				exitGame(Strings.substitute(message, money));
				
				Global.addExperience(3);
				Global.sendAchievement("ac27;","Garbage Collector");
			}
		}
		
		private function exitGame(text : String) : void
		{
			_hasToExit = true;
			var dialog : DialogOkView = Dialogs.showOkDialog(text, true, null, true);
			dialog.ok.addListener(onExitClick);
		}
		private function onBonusTime(time : uint) : void
		{
			var bonusText : TextField = Background(content).bonusText;
			bonusText.text = resourceBundle.messages.bonusTime + ": " + time;
			bonusText.visible = time != 0;
		}
		private function onRulesOk() : void
		{
			var ready : ReadyClient = new ReadyClient(remoteId);
			ready.ready.addListener(onReady);
			_waitingDialog = new DialogView(Global.resourceBundles.kavalok.messages.waitingForOtherPlayers, false);
			_waitingDialog.show();
		}
		
		private function onReady() : void
		{
			_waitingDialog.hide();
			_waitingDialog = null;
			_particlesManager.team = _team;
			_weaponEntry.team = _team;
			_particlesManager.start();
			super.restoreState(_state);
		}
		
		private function refreshCharsCount() : void
		{
			if(states == null || _hasToExit)
				return;
			var teams : ArrayList = new ArrayList();
			for(var name : String in states)
			{
				if(isCharState(name))
				{
					if(states[name] == null)
						continue;
					var team : uint = states[name].team;
					if(!teams.contains(team))
					{
						teams.addItem(team);
					}
				}
			}
//			if(teams.length < 2)
//			{
//				_hasToExit = true;
//				exitGame(resourceBundle.messages.otherTeamExit);
//			}
		}
		
		private function onExitClick(e:Event = null) : void
		{
			_hasToExit = true;
			if(_waitingDialog != null)
			{
				_waitingDialog.hide();
				_waitingDialog = null;
			}
			Global.locationManager.returnToPrevLoc();
		}
		override protected function get initialCoords():Point
		{
			var result : Point = new Point(0, 385);
			result.x = (_team == 1) ? 18 : 860;
			return result;
		}

		private function getTeamScore(team : uint) : TextField
		{
			return content[SCORE_PREFIX + team].text;
		}

		
		private function onCollision() : void
		{
			sendIncreaseScore();
			sendAddBonus(MONEY_FOR_COLLISION, Competitions.GARBAGE_COLLECTOR);
			new CompetitionService().addResult(Competitions.GARBAGE_COLLECTOR, MONEY_FOR_COLLISION);
		}
		
		private function sendIncreaseScore() : void
		{
			send("rIncreaseScore", _team);
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			_particlesManager.destroy();
		}
		
	}
}