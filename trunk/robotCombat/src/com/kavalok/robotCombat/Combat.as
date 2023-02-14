package com.kavalok.robotCombat
{
	import com.kavalok.Global;
	import com.kavalok.events.EventSender;
	import com.kavalok.robots.Robot;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	
	public class Combat
	{
		static public const TIME_LIMIT:int = 20;
		
		static private var _instance:Combat;
		static public function get instance():Combat
		{
			if (!_instance)
				_instance = new Combat(new Singleton());
				
			return _instance;
		}
		
		public var root:Sprite;
		public var client:CombatClient;
		public var finished:Boolean = false;
		
		private var _changeEvent:EventSender = new EventSender();
		private var _dataReadyEvent:EventSender = new EventSender();
		
		private var _myPlayer:CombatPlayer;
		private var _opponentPlayer:CombatPlayer;
		
		public function Combat(oblect:Singleton)
		{
			Global.music.play(['combat_theme']);
			_myPlayer = new CombatPlayer(Global.charManager.userId);
			_opponentPlayer = new CombatPlayer(RobotCombat.instance.opponentId);
		}
		
		public function getPlayer(userId:int):CombatPlayer
		{
			return (userId == _myPlayer.userId)
				? myPlayer
				: opponentPlayer;
		}
		
		public function dispatchReady():void 
		{
			_dataReadyEvent.sendEvent();
		}
		
		public function dispatchChange():void
		{
	 		_changeEvent.sendEvent();
		}
		
		public function addEnergy(robot:Robot, value:int):void
		{
			robot.energy = GraphUtils.claimRange(robot.energy + value, 0, robot.maxEnergy);
			dispatchChange();
		}
		
		public function setEnergy(robot:Robot, value:int):void
		{
			robot.energy = GraphUtils.claimRange(value, 0, robot.maxEnergy);
			dispatchChange();
		}
		
		public function get myPlayer():CombatPlayer { return _myPlayer; }
		public function get opponentPlayer():CombatPlayer { return _opponentPlayer; }
		
		public function get changeEvent():EventSender { return _changeEvent; }
		public function get dataReadyEvent():EventSender { return _dataReadyEvent; }
		
	}
}

internal class Singleton
{
}