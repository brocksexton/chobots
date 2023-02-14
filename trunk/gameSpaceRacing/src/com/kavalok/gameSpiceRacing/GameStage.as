package com.kavalok.gameSpiceRacing
{
	import com.kavalok.Global;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.services.CompetitionService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SyncClient;
	import com.kavalok.utils.converting.ToPropertyValueConverter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	import com.junkbyte.console.Cc; // console
	
	public class GameStage extends ClientBase
	{
		private var _content:McGameContent = new McGameContent();
		private var _synchronizer:SyncClient;
		
		private var _players:Object = {};
		private var _user:Player;
		private var _updateTimer:Timer;
		private var _bounds:Rectangle;
		private var _space:Space;
		private var _controls:ControlView = new ControlView(_content);
		private var _closeEvent:EventSender = new EventSender();
		private var _starField:StarField;
		private var _counter:McStartCounter;;
		private var _events:EventManager = new EventManager();
		private var _finished:Boolean;
		
		private var _bundle:ResourceBundle = Localiztion.getBundle('gameSpaceRacing');
		
		private var _okDialog:DialogOkView;
		
		public function GameStage(remoteId:String)
		{
			_remoteId = remoteId;
			
			var bounds:Rectangle = _content.mcSpace.getBounds(_content.mcSpace);
			
			createStarField(bounds);
			createSpace(bounds);
			
			_controls.closeEvent.addListener(_closeEvent.sendEvent);
			_bundle.registerTextField(_content.txtFuel);
			
			showInfo();
			//connectToGame();
		}
		
		override public function get id():String
		{
			return "GameStage";
		}
		
		private function createSpace(bounds:Rectangle):void
		{
			_space = new Space(bounds);
			_space.content.x = _content.mcSpace.x;
			_space.content.y = _content.mcSpace.y
					+ Config.PLAYER_POSITION * _space.pageHeight
					- _space.mcStart.y;
			_space.content.mask = _content.mcSpace;
			
			GraphUtils.attachAfter(_space.content, _starField.content);
		}
		
		private function createStarField(bounds:Rectangle):void
		{
			_starField = new StarField(bounds);
			_starField.createStars(McStar, 25);
			_starField.createStars(McSpaceObject1, 1);
			_starField.createStars(McSpaceObject2, 1);
			_starField.createStars(McSpaceObject4, 1);
			
			GraphUtils.attachAfter(_starField.content, _content.mcBg);
		}
		
		private function showInfo():void
		{
			var info:McInfo = new McInfo();
			_bundle.registerTextField(info.txtRules);
			_bundle.registerTextField(info.txtSlow);
			_bundle.registerTextField(info.txtFast);
			_bundle.registerTextField(info.txtFuel);
			_bundle.registerTextField(info.txtBio);
			
			var dialog:DialogOkView = Dialogs.showOkDialog(null, true, info);
			dialog.ok.addListener(connectToGame);
		}
		
		private function connectToGame():void
		{
			_okDialog = Dialogs.showOkDialog(Global.messages.waitingForOtherPlayers, false, null, false);
			connectEvent.addListener(onConnect);
			connect(remoteId);
		}
		
		private function onConnect():void
		{
			var state:Object = Global.charManager.getCharState();
			sendUserState(null, state);
			
			_synchronizer = new SyncClient(remoteId);
			_synchronizer.readyEvent.setListener(onReady);
			_synchronizer.actionId = 'ready';
			_synchronizer.sendReady();
		}
		
		private function onReady():void
		{
			if (remoteId == Config.DEBUG_REMOTE_ID
				&& remote.connectedChars.length < Config.DEBUG_PAYERS_COUNT)
				return;
			send("rSetReady");
		}
		
		public function rMap(map:Array):void
		{
			_space.build(map);
			createPlayers();
			_updateTimer = new Timer(1000 * Config.UPDATE_INTERVAL);
			_updateTimer.addEventListener(TimerEvent.TIMER, sendUpdate);
			_user.time = new Date().time;
			
			hideDialog();
			
			_counter = new McStartCounter();
			_events.registerEvent(_counter, 'sound', playCounterSound);
			_events.registerEvent(_counter, Event.COMPLETE, activate);
			_content.addChild(_counter);
		}
		
		private function playCounterSound(e:Event):void
		{
			Global.playSound(snd_shutle_move);
		}
		
		private function createPlayers():void
		{
			var ids:Array = remote.connectedChars;
			ids.sort();
			var numPlayers:int = ids.length;
			
			for (var i:int = 0; i < numPlayers; i++)
			{
				var slot:McSlot = _space.mcStart['mcSlot' + i];
				
				var player:Player = new Player(ids[i], i, _space);
				player.model.x = slot.x;
				player.model.y = _space.mcStart.y;
				player.setFire(0);
				
				_players[player.id] = player;
				_space.content.addChild(player.model);
				_controls.addPlayer(player);
				slot.txtName.text = player.id;
				if (player.id == clientCharId)
				{
					_user = player;
					var format:TextFormat = slot.txtName.defaultTextFormat;
					format.color = 0xFF0000;
					slot.txtName.setTextFormat(format);
				}
			}
		}
		
		private function sendUpdate(e:Event):void
		{
			if(connected)
				send('rUpdatePlayer', _user.id, _user.model.x, _user.model.y);
		}
		
		public function rUpdatePlayer(playerId:String, x:int, y:int):void
		{
			var player:Player = _players[playerId];
			
			if (player && player.id != _user.id)
				player.moveTo(x, y);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (_finished)
				return;
			
			for each (var player:Player in _players)
			{
				if (!player.atFinish)
					player.move();
				_controls.refreshPlayer(player);
			}
			
			if (!_user.atFinish)
			{
				_user.control();
				_user.checkColisions();
				_user.processFuel();
				
				_starField.move(-0.7 * _user.body.v.x, -0.7 * _user.body.v.y)
				_controls.fuel = _user.fuel;
				_controls.time = new Date().time - _user.time;
				_space.doStep();
				_space.content.y = _content.mcSpace.y
					+ Config.PLAYER_POSITION * _space.pageHeight
					- _user.model.y;
				
				if (_user.model.y <= _space.mcFinish.y)
					finish();
			}
		}
		
		private function finish():void
		{
			_user.model.y = _space.mcFinish.y;
			_user.time = new Date().time - _user.time;
			_user.atFinish = true;
			destroyTimer();

			send('rFinish', _user.id, _user.time);
		}
		
		public function rFinish(playerId:String, time:Number):void
		{
			if ( !(playerId in _players) )
				return;
			
			var player:Player = _players[playerId];
			player.time = time;
			player.atFinish = true;
			player.hideFire();
			player.model.y = _space.mcFinish.y;
			
			if (!_finished)
				checkFinish();
		}
		
		private function checkFinish():void
		{
			var atFinishCount:int = 0;
			var inGameCount:int = 0;
			
			for each (var p:Player in _players)
			{
				if (p.atFinish)
					atFinishCount++;
				else
					inGameCount++;
			}
			
			if (inGameCount <= 1)
			{
				_finished = true;
				showResult();
			}
		}
		
		private function showResult():void
		{
			var result:Array = [];
			
			for each (var player:Player in _players)
			{
				result.push(player);
			}
			
			result.sortOn('time', Array.NUMERIC);
			
			var winer : Boolean = (clientCharId == Player(result[0]).id); 
			var money:int = winer
				? Config.MONEY_WIN
				: Config.MONEY_LOST;
			
			Cc.warn("> going to add money??");
			
			if(winer && result.length > 1) { // moved AddMoneyCommand under here
				Cc.warn("is winner, adding bugs");
				new AddMoneyCommand(money, Competitions.SPACE_RACING).execute();
				new CompetitionService().addCompetitorResult(Player(result[1]).id, Competitions.SPACE_RACING, 1);
				Global.addExperience(2);
				Global.sendAchievement("ac26;","Win any contest");
			}

			var ids : ArrayList = Arrays.getConverted(result, new ToPropertyValueConverter("id"));

			var dialog:DialogOkView = Dialogs.showGameResults(ids, states);
			dialog.ok.addListener(_closeEvent.sendEvent);
		}
		
		private function activate(e:Event = null):void
		{
			_updateTimer.start();
			_events.registerEvent(content, Event.ENTER_FRAME, onEnterFrame);
		}
		
		override public function charDisconnect(charId:String):void
		{
			super.charDisconnect(charId);
			
			var player:Player = _players[charId];
			if (player && !player.atFinish)
			{
				delete _players[charId];
				GraphUtils.detachFromDisplay(player.model);
				GraphUtils.detachFromDisplay(player.marker);
			}
			
			if (!_finished)
				checkFinish();
		}
		
		private function hideDialog():void
		{
			if (_okDialog)
			{
				_okDialog.hide();
				_okDialog = null;
			}
		}
		
		public function destroy():void
		{
			destroyTimer();
			hideDialog();
			remote.dispose();
			
			_events.clearEvents();
			
			for each (var player:Player in _players)
			{
				player.destroy();
			}
		}
		
		private function destroyTimer():void
		{
			if (_updateTimer)
			{
				_updateTimer.stop();
				_updateTimer = null;
			}
		}
		
		public function get content():Sprite { return _content; }
		
		public function get closeEvent():EventSender { return _closeEvent; }
	}
	
}