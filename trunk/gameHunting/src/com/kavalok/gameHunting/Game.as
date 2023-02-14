package com.kavalok.gameHunting
{
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.DialogView;
	import com.kavalok.gameHunting.data.HealthData;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.controls.RectangleSprite;
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogViewBase;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameHunting.data.PlayerData;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import flash.display.Sprite;
	
	import gameHunting.McHuntingStage;
	
	public class Game
	{
		private var _closeEvent:EventSender = new EventSender();
		private var _content:McHuntingStage = new McHuntingStage();
		private var _view:GameView;
		private var _client:GameClient = new GameClient();
		private var _dialog:DialogViewBase;
		private var _target:Target;
		private var _hand:Hand;
		private var _shells:Array = [];
		private var _players:Array = [];
		private var _updateTimer:Timer = new Timer(Config.UPDATE_INTERVAL);
		
		public function Game(remoteId:String)
		{
			ShellFactory.initialize();
			initialize();
			_content.shellBox.visible = false;
			_client.connect(remoteId || Config.DEBUG_REMOTE_ID);
			_updateTimer.addEventListener(TimerEvent.TIMER, onUpdateTimer);
			trace('remoteObject:', _client.remoteId);
			trace('connectedChars: ', _client.remote.connectedChars.length);
		}
		
		//{ region initialize
		private function initialize():void
		{
			GraphUtils.optimizeBackground(_content.background);
						
			_view = new GameView(_content);
			_view.currentShell = 'shell1';
			_view.closeEvent.addListener(closeGame);
			_view.changeShellEvent.addListener(onShellChange);
			_dialog = Dialogs.showOkDialog(Global.messages.waitingForOtherPlayers, false, null, false);
			
			_client.connectEvent.addListener(createPlayer);
			_client.cancelEvent.addListener(onClientCancel);
			_client.playerCreateEvent.addListener(onPlayerCreated);
			_client.healthEvent.addListener(onHealth);
			_client.victoryEvent.addListener(onVictory);
			_client.positionEvent.addListener(onPosition);
			
			_content.targetClip.mouseEnabled = false;
			_content.targetClip.mouseChildren = false;
			_content.handClip.mouseEnabled = false;
			_content.handClip.mouseChildren = false;
			
			_content.clickArea.cacheAsBitmap = true;
			_content.clickArea.alpha = 0;
			_content.clickArea.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			
			_target = new Target(_content.targetClip);
			_hand = new Hand(_content.handClip);
			_hand.setModel(_view.currentShell);
			_hand.setPosition(_content.mouseX);
		}
		
		private function createPlayer():void
		{
			var data:PlayerData = new PlayerData();
			data.charId = Global.charManager.charId;
			data.body = Global.charManager.body;
			data.color = Global.charManager.color;
			data.clothes = Global.charManager.stuffs.getUsedClothes();
			
			_client.createPlayer(data);
		}
		
		private function onPlayerCreated(data:PlayerData):void
		{
			var player:Player = new Player(data);
			_players.push(player);
			_view.updatePlayer(player);
			
			if (_players.length == 2)
			{
				_players.sortOn('name');
				startGame();
			}
			/*else if (_client.remote.connectedChars.length < 2 && _client.remoteId != Config.DEBUG_REMOTE_ID)
			{
				closeGame();
				_dialog.hide();
			}*/
		}
		//} endregion
		
		//{ region game
		private function startGame():void
		{
			_dialog.hide();
			_dialog = null;
			_target.player = otherPlayer;
			
			_content.shellBox.visible = true;
			_content.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_updateTimer.start();
		}
		
		private function onUpdateTimer(e:TimerEvent):void
		{
			if (Config.BOT_MODE)
				_client.setPosition(Math.random());
			else
				_client.setPosition(_hand.position);
		}
		
		private function onPosition(position:Number):void
		{
			_target.position = position;
		}
		
		private function onEnterFrame(e:Event):void
		{
			_target.processFrame();
			var shellsCopy:Array = _shells.slice();
			for each (var shell:Shell in shellsCopy)
			{
				shell.move();
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			_hand.setPosition(_content.mouseX);
			e.updateAfterEvent();
		}
		
		private function onShellChange():void
		{
			_hand.setModel(_view.currentShell);
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (_hand.ready)
			{
				createShell();
				_hand.createModel();
			}
		}
		
		private function createShell():void
		{
			var shell:Shell = new Shell(_hand.shellInfo);
			shell.onMaximum = checkTarget;
			shell.onFinish = removeShell;
			shell.name = _hand.shellName;
			GraphUtils.setCoords(shell.content, _hand.item);
			_shells.push(shell);
			_content.targetClip.addChild(shell.content);
			Global.playSound(_hand.shellInfo.classSoundGo);
		}
		
		private function removeShell(shell:Shell):void
		{
			Arrays.removeItem(shell, _shells);
			GraphUtils.detachFromDisplay(shell.content);
		}
		
		private function checkTarget(shell:Shell):void
		{
			var point:Point = new Point(
				shell.content.x,
				shell.content.y);
			point = _content.localToGlobal(point);
				
			if (_target.hitArea.hitTestPoint(point.x, point.y, false))
			{
				Global.playSound(shell.info.classSoundHit);
				shell.content.parent.setChildIndex(shell.content, 1);
				shell.playAnimation();
				
				var data:HealthData = new HealthData();
				data.charId = otherPlayer.data.charId;
				data.health = shell.info.health;
				data.shellName = shell.name;
				_client.setHealth(data);
				_target.hit();
			}
			else
			{
				GraphUtils.sendToBack(shell.content);
			}
		}
		
		private function onHealth(data:HealthData):void
		{
			var player:Player = getPlayer(data.charId);
			player.data.health = Math.max(player.data.health - data.health, 0);
			_view.updatePlayer(player);
			
			if (player.isMe)
				_view.showShell(data.shellName);
			
			if (isMain)
			{
				if (myPlayer.health == 0)
					_client.sendVictory(otherPlayer.data.charId);
				if (otherPlayer.health == 0)
					_client.sendVictory(myPlayer.data.charId);
			}
		}
		
		private function onVictory(charId:String):void
		{
			if (_client.connected)
			{
				var result:Array = [];
				var player:Player = getPlayer(charId);
				result.push(player.data.charId);
				
				if (player.isMe)
				{
					result.push(otherPlayer.data.charId);
					new AddMoneyCommand(Config.MONEY_WIN, Config.GAME_ID, true).execute();
				}
				else
				{
					result.push(myPlayer.data.charId);
					new AddMoneyCommand(Config.MONEY_LOST, Config.GAME_ID, true).execute();
				}
				
				var dialog:DialogOkView = Dialogs.showGameResults(result, _client.allStates);
				dialog.ok.addListener(onOk);
				dispose();
			}
		}
		
		private function onOk():void
		{
			closeGame();
		}
		
		//} endregion
		
		//{ region dispose
		private function onClientCancel():void
		{
			closeGame();
		}
		
		private function finish():void
		{
		}
		
		private function closeGame():void
		{
			dispose();
			_closeEvent.sendEvent();
		}
		
		private function dispose():void
		{
			if (!_client.connected)
				return;
				
			if (_dialog)
				_dialog.hide();
			
			_updateTimer.stop();
			_client.remote.dispose();
			_hand.content.visible = false;
			_content.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function get otherPlayer():Player
		{
			var player0:Player = _players[0];
			var player1:Player = _players[1];
			
			return (player0.isMe) ? player1 : player0;
		}
		
		public function get myPlayer():Player
		{
			var player0:Player = _players[0];
			var player1:Player = _players[1];
			
			return (player0.isMe) ? player0 : player1;
		}
		
		public function getPlayer(charId:String):Player
		{
			var player0:Player = _players[0];
			var player1:Player = _players[1];
			
			return (player0.data.charId == charId) ? player0 : player1;
		}
		
		public function get isMain():Boolean
		{
			return Global.charManager.charId == Player(_players[0]).data.charId;
		}
		
		//} endregion
		
		public function get closeEvent():EventSender { return _closeEvent; }
		
		public function get content():Sprite { return _content; }
	}
	
}