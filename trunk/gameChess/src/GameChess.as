package
{
	import com.kavalok.gameChess.Cell;
	import com.kavalok.gameChess.Chess;
	import com.kavalok.gameChess.GameClient;
	import com.kavalok.gameChess.GameController;
	import com.kavalok.gameChess.Item;
	import com.kavalok.Global;
	import com.kavalok.modules.ModuleBase;
	import com.kavalok.struct.Array2D;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.TypeRequirement;
	
	import gameChess.McGameWindow;
	
	public class GameChess extends ModuleBase
	{
		
		static private var _instance:GameChess;
		
		private var _client:GameClient = new GameClient();
		private var _content:McGameWindow = new McGameWindow();
		private var _cells:Array2D = new Array2D(Chess.SIZE, Chess.SIZE);
		private var _items:Array = [];
		private var _myKing:Item;
		
		override public function initialize():void
		{
			_instance = this;
			var game:GameController = new GameController();
			game.readyEvent.addListener(readyEvent.sendEvent);
		}
		
		public function get playerNum():int
		{
			return parameters.playerNum;
		}
		
		public function get otherPlayerNum():int
		{
			return 1 - playerNum;
		}
		
		public function get remoteId():String
		{
			return parameters.remoteId;
		}
		
		public function getMyItems():Array
		{
			var result:Array = [];
			for each (var item:Item in _items)
			{
				if (item && item.playerNum == playerNum)
					result.push(item);
			}
			return result;
		}
		
		public function getHisItems():Array
		{
			var result:Array = [];
			for each (var item:Item in _items)
			{
				if (item && item.playerNum == otherPlayerNum)
					result.push(item);
			}
			return result;
		}
		
		public function getCellByItem(item:Item):Cell
		{
			return _cells.getItem(item.row, item.col) as Cell;
		}
		
		public function getItem(row:int, col:int):Item
		{
			return Cell(_cells.getItem(row, col)).item;
		}
		
		public function getCell(row:int, col:int):Cell
		{
			return _cells.getItem(row, col) as Cell;
		}
		
		static public function get instance():GameChess { return _instance; }
		
		public function get client():GameClient { return _client; }
		public function get content():McGameWindow { return _content; }
		public function get cells():Array2D { return _cells; }
		public function get items():Array { return _items; }
		
		public function get myKing():Item {	return _myKing; }
		
		public function set myKing(value:Item):void
		{
			_myKing = value;
		}
		
	}
	
}