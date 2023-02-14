package com.kavalok.gameChess
{
	import com.kavalok.char.Char;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameChess.data.ItemData;
	import com.kavalok.gameChess.data.PlayerState;
	import com.kavalok.gameChess.view.MainView;
	import com.kavalok.gameChess.view.PlayersView;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.Global;
	import com.kavalok.services.CompetitionService;
	import com.kavalok.utils.GraphUtils;
	import flash.events.Event;
	import gameChess.McGameWindow;
	
	public class GameController extends Controller
	{
		static public const MONEY_WIN:int = 100;
		static public const MONEY_LOST:int = 10;
		
		private var _readyEvent:EventSender = new EventSender();
		private var _itemsCreated:int = 0;
		private var _itemsToSend:Array = [];
		
		public function GameController()
		{
			Chess.initFactory();
			createCells();
			initView();
			
			new DeskController();
			
			client.connectEvent.addListener(onConnect);
			client.playerAddEvent.addListener(onPlayerAdded);
			client.victoryEvent.addListener(onVictory);
			
			client.connect(game.remoteId);
			
			Global.tableGameCloseEvent.addListener(onTableDispose);
		}
		
		
		private function initView():void
		{
			new MainView().closeEvent.addListener(onCloseClick);
			new PlayersView(game.content);
			
			Global.borderContainer.addChild(game.content);
			GraphUtils.alignCenter(game.content, KavalokConstants.SCREEN_RECT);
		}
		
		private function onCloseClick():void
		{
			if (client.connected)
				Global.tableGameCloseEvent.sendEvent(game.remoteId);
			else
				GraphUtils.detachFromDisplay(game.content);
		}
		
		private function onTableDispose(remoteId:String):void
		{
			if (remoteId != game.remoteId)
				return;
			
			Global.tableGameCloseEvent.removeListener(onTableDispose);
			
			if (client.connected)
			{
				game.client.disconnect();
				GraphUtils.detachFromDisplay(game.content);
			}
		}
		
		private function onVictory(winner:int):void
		{
			if (winner == game.playerNum)
			{
				new AddMoneyCommand(MONEY_WIN, "chess").execute();
				Global.addExperience(2);
				var looser:String = String(Char(game.client.players[1 - winner]).userId);
				new CompetitionService().addCompetitorResult(
					looser, Competitions.CHESS, 1);
			}
			else
			{
				new AddMoneyCommand(MONEY_LOST, "chess").execute();
			}
				
			client.disconnect();
			Global.tableGameCloseEvent.sendEvent(game.remoteId);
		}
		
		private function onConnect():void
		{
			if (game.playerNum >= 0)
				createPlayer();
				
			_readyEvent.sendEvent();
		}
		
		private function createPlayer():void
		{
			var state:PlayerState = new PlayerState();
			
			state.id = Global.charManager.charId;
			state.body = Global.charManager.body;
			state.color = Global.charManager.color;
			state.clothes = Global.charManager.stuffs.getUsedClothes();
			state.tool = Global.charManager.tool;
			state.index = game.playerNum;
			
			client.sendAddPlayer(state);
		}
		
		private function onPlayerAdded(playerNum:int):void
		{
			if (game.playerNum == 0 && client.numPlayers == 2)
			{
				_itemsCreated = 0;
				client.itemAddEvent.addListener(onItemAdded);
				createItems();
				game.content.addEventListener(Event.ENTER_FRAME, sendItem); //quick fix
			}
		}
		
		private function sendItem(e:Event):void
		{
			var itemData:ItemData = _itemsToSend.pop();
			client.sendAddItem(itemData);
			
			if (_itemsToSend.length == 0)
				game.content.removeEventListener(Event.ENTER_FRAME, sendItem);
		}
		
		private function onItemAdded(data:ItemData):void
		{
			if (++_itemsCreated == 32)
			{
				client.itemAddEvent.removeListener(onItemAdded);
				client.sendActivatePlayer(game.playerNum);
			}
		}
		
		public function createItems():void
		{
			var itemId:int = 0;
			var items:Array = Chess.getDisposition();
			
			for (var i:int = 0; i < items.length; i++)
			{
				var row:Array = items[i];
				for (var j:int = 0; j < row.length; j++)
				{
					var itemType:String = row[j];
					if (itemType)
					{
						createItem(itemId, itemType, i, j);
						itemId++;
					}
				}
			}
		}
		
		private function createItem(id:int, type:String, row:int, col:int):void
		{
			var itemData:ItemData = new ItemData();
			itemData.id = id;
			itemData.type = type;
			itemData.row = row;
			itemData.col = col;
			itemData.playerNum = (row < 2) ? 1 : 0;
			
			_itemsToSend.push(itemData)
		}
		
		private function createCells():void
		{
			for (var i:int = 0; i < Chess.SIZE; i++)
			{
				for (var j:int = 0; j < Chess.SIZE; j++)
				{
					var cell:Cell = new Cell(i, j);
					game.cells.setItem(cell, i, j);
				}
			}
		}
		
		public function get readyEvent():EventSender { return _readyEvent; }
		
	}
	
}