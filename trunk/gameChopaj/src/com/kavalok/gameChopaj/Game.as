package com.kavalok.gameChopaj
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameChopaj.data.FireData;
	import com.kavalok.gameChopaj.data.ItemData;
	import com.kavalok.gameChopaj.data.PlayerData;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.Global;
	import com.kavalok.services.CompetitionService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	import com.kavalok.utils.Debug;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Timers;
	import flash.display.MovieClip;
	import gameChopaj.McGameWindow;
	import gameChopaj.SndThrow;
	
	public class Game
	{
		static public const MONEY_WIN:int = 100;
		static public const MONEY_LOST:int = 10;
		
		static private var _instance:Game;
		
		private var _readyEvent:EventSender = new EventSender();
		
		private var _content:McGameWindow = new McGameWindow();
		private var _view:GameView;
		private var _desk:Desk;
		private var _client:GameClient = new GameClient();
		private var _playerNum:int;
		private var _remoteId:String;
		private var _players:Array = [null, null];
		private var _items:Array = [];
		private var _activePlayerNum:int = 0;
		private var _engine:Engine;
		
		//{ region start game
		public function Game(playerNum:int, remoteId:String, wallScale:Number)
		{
			_instance = this;
			_playerNum = playerNum;
			_remoteId = remoteId;
			
			_desk = new Desk(wallScale);
			
			_engine = new Engine(_content.deskClip.background.getBounds(_content.deskClip));
			_engine.completeEvent.addListener(onEngineComplete);
			
			_view = new GameView();
			_view.closeEvent.addListener(onCloseClick);
			
			_client.connectEvent.addListener(onConnect);
			_client.victoryEvent.addListener(onVictory);
			_client.playerAddEvent.addListener(onPlayerAdded);
			_client.playerRemoveEvent.addListener(onPlayerRemoved);
			_client.playerActivateEvent.addListener(onPlayerActivate);
			_client.itemsUpdateEvent.addListener(onItemsUpdated);
			_client.itemActivateEvent.addListener(onItemActivate);
			_client.fireEvent.addListener(onItemFire);
			_client.connect(_remoteId);
			
			Global.borderContainer.addChild(_content);
			Global.tableGameCloseEvent.addListener(onTableDispose);
			GraphUtils.alignCenter(_content, KavalokConstants.SCREEN_RECT);
		}
		
		private function onConnect():void
		{
			if (!isSpectator)
				createPlayer();
				
			_readyEvent.sendEvent();
		}
		
		private function createPlayer():void
		{
			var data:PlayerData = new PlayerData();
			data.id = Global.charManager.charId;
			data.userId = Global.charManager.userId;
			data.body = Global.charManager.body;
			data.color = Global.charManager.color;
			data.clothes = Global.charManager.stuffs.getUsedClothes();
			data.tool = Global.charManager.tool;
			data.playerNum = _playerNum;
			
			_client.sendAddPlayer(data);
		}
		
		private function onPlayerAdded(data:PlayerData):void
		{
			_players[data.playerNum] = data;
			_view.addPlayer(data);
			
			if (isMainPlayer)
			{
				PlayerData(_players[0]).rowNum = 7;
				PlayerData(_players[1]).rowNum = 0;
				createRound();
			}
		}
		
		private function onPlayerRemoved(playerNum:int):void
		{
			_players[playerNum] = null;
			_view.removePalyer(playerNum);
			enableItems(false);
		}
		
		private function createRound():void
		{
			var itemIndex:int = 0;
			var itemsList:Array = [];
			for (var playerNum:int = 0; playerNum < 2; playerNum++)
			{
				var player:PlayerData = _players[playerNum];
				for (var j:int = 0; j < 8; j++)
				{
					var data:ItemData = new ItemData();
					
					data.index = itemIndex;
					data.playerNum = playerNum;
					data.x = Desk.getX(j);
					data.y = Desk.getY(player.rowNum);
					itemsList.push(data);
					itemIndex++;
				}
			}
			
			_client.sendItems(itemsList);
		}
		//} endregion
		
		private function onItemsUpdated(itemsData:Array):void
		{
			_engine.stop();
			createItems(itemsData);
			_desk.refreshItems();
			
			if (isMainPlayer)
				checkResult();
		}
		
		private function checkResult():void
		{
			var player0:PlayerData = _players[0];
			var player1:PlayerData = _players[1];
			var count0:int = getForPlayer(0).length;
			var count1:int = getForPlayer(1).length;
				
			if (count0 == 0 && count1 == 0)
			{
				_client.sendVictory(-1);
				//createRound();
			}
			else if (count0 == 0)
			{
				//_activePlayerNum = 0;
				//player1.rowNum++;
				//if (player1.rowNum == 4)
					_client.sendVictory(1);
				//else
				//	createRound();
			}
			else if (count1 == 0)
			{
				//_activePlayerNum = 1;
				//player0.rowNum--;
				//if (player0.rowNum == 3)
					_client.sendVictory(0);
				//else
				//	createRound();
			}
			else
			{
				_client.sendActivatePlayer(1 - _activePlayerNum);
			}
		}
		
		private function createItems(itemsData:Array):void
		{
			for (var i:int = 0; i < itemsData.length; i++)
			{
				var data:ItemData = itemsData[i];
				var item:Item;
				if (data)
				{
					item = new Item(data);
					if (item.isMy)
					{
						item.pressEvent.addListener(onItemPressed);
						item.fireEvent.addListener(onItemReleased);
					}
				}
				else
				{
					item = null;
				}
				_items[i] = item;
			}
		}
		
		private function onPlayerActivate(playerNum:int):void
		{
			_activePlayerNum = playerNum;
			_view.setActivePlayer(_activePlayerNum);
			
			if (_activePlayerNum == _playerNum)
				enableItems(true);
		}
		
		private function onItemPressed(item:Item):void
		{
			client.sendActiveItem(_items.indexOf(item));
		}
		
		private function onItemActivate(itemIndex:int):void
		{
			_desk.setActiveItem(_items[itemIndex]);
		}
		
		private function onItemReleased(item:Item):void
		{
			enableItems(false);
			_client.sendFire(item.fireData);
		}
		
		private function onItemFire(data:FireData):void
		{
			Global.playSound(SndThrow);
			_desk.setActiveItem(null);
			_engine.start(data);
		}
		
		private function onEngineComplete():void
		{
			if (!isSpectator && _activePlayerNum != _playerNum)
				sendUpdate();
		}
		
		private function sendUpdate():void
		{
			var result:Array = [];
			for each (var item:Item in _items)
			{
				if (item)
				{
					item.updateData()
					result.push(item.data);
				}
				else
				{
					result.push(null);
				}
			}
			_client.sendItems(result);
		}
		
		//{ region close handlers
		private function onVictory(winPlayerNum:int):void
		{
			if (winPlayerNum == _playerNum)
			{
				new AddMoneyCommand(MONEY_WIN, "gameChopaj").execute();
				
				var looser:String = String(PlayerData(_players[1 - winPlayerNum]).userId);
				new CompetitionService().addCompetitorResult(
					looser, Competitions.CHOPAJ, 1);
			}
			else
			{
				new AddMoneyCommand(MONEY_LOST, "gameChopaj").execute();
			}
				
			_client.disconnect();
			_view.setDancePlayer(winPlayerNum);
			Global.tableGameCloseEvent.sendEvent(_remoteId);
		}
		
		private function onCloseClick():void
		{
			if (_client.connected)
				Global.tableGameCloseEvent.sendEvent(_remoteId);
			else
				GraphUtils.detachFromDisplay(_content);
		}
		
		private function onTableDispose(remoteId:String):void
		{
			if (remoteId != remoteId)
				return;
			
			_engine.stop();
				
			Global.tableGameCloseEvent.removeListener(onTableDispose);
			
			if (client.connected)
			{
				_client.disconnect();
				GraphUtils.detachFromDisplay(_content);
			}
		}
		//} endregion
		
		public function enableItems(value:Boolean):void
		{
			var items:Array = getMyItems();
			for each (var item:Item in items)
			{
				item.enabled = value;
			}
		}
		
		public function get isSpectator():Boolean
		{
			return _playerNum == -1;
		}
		
		public function get isMainPlayer():Boolean
		{
			return _players[0] && _players[1] &&
				PlayerData(_players[0]).id == Global.charManager.charId;
		}
		
		public function getAllItems():Array
		{
			var result:Array = [];
			for each (var item:Item in _items)
			{
				if (item)
					result.push(item);
			}
			return result;
		}
		
		public function getMyItems():Array
		{
			return getForPlayer(_playerNum);
		}
		
		public function getForPlayer(playerNum:int):Array
		{
			return Arrays.getByRequirement(getAllItems(),
				new PropertyCompareRequirement('playerNum', playerNum));
		}
		
		static public function get instance():Game { return _instance; }
		
		public function get content():McGameWindow { return _content; }
		public function get client():GameClient { return _client; }
		public function get playerNum():int { return _playerNum; }
		public function get players():Array { return _players; }
		public function get items():Array { return _items; }
		
		public function get readyEvent():EventSender { return _readyEvent; }
		
	}
	
}