package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.fightAction.IFightAction;
	
	public class StaticActionBase
	{
		private var _stage:GameStage;
		
		protected var _countTotal:int = -1;
		protected var _showModel:Class = PlayerModelStay;
		
		private var _fightEvent:EventSender = new EventSender();
		
		private var _enabled:Boolean;
		private var _fightActionType:Class;
		
		public function get enabled():Boolean { return _enabled; }
		public function set stage(value : GameStage):void { _stage = value; }
		public function get stage():GameStage { return _stage; }
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = (value && _countTotal != 0);
		}
		
		public function get id():String { return ''; }
		
		public function get countTotal():int { return _countTotal; }
		
		public function get showModel():Class { return _showModel; }
		
		public function get fightEvent():EventSender { return _fightEvent; }
		
		public function StaticActionBase(fightType : Class) 
		{
			super();
			_fightActionType = fightType;
		}

		public function createAction(player : Player, params : Object) : IFightAction
		{
			var action : IFightAction = new _fightActionType(stage, player, params);
			return action;
		}

		public function addCount(value:int):void
		{
			if (_countTotal > 0) 
				_countTotal += value;
				
			_enabled = _enabled && _countTotal != 0;
		}
	
		public function activate():void { }
		public function terminate():void { }
		
		protected function sendFightEvent(object : Object) : void
		{
			object.actionId = id;
			fightEvent.sendEvent(object);	
		}
		
	}
	
}