package com.kavalok.robotCombat 
{
	import com.kavalok.char.Char;
	import com.kavalok.dto.robot.CombatActionTO;
	import com.kavalok.dto.robot.CombatResultTO;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.robotCombat.commands.ApplyResultCommand;
	import com.kavalok.robotCombat.commands.CheckEnergyCommand;
	import com.kavalok.robotCombat.commands.OpponentDisconnectCommand;
	import com.kavalok.robotCombat.view.MainView;
	import com.kavalok.robots.Robot;
	import com.kavalok.services.RobotServiceNT;
	/**
	 * ...
	 * @author Canab
	 */
	public class CombatClient extends ClientBase 
	{
		static private const REMOTE_PREFIX:String = 'combat|';
		static private const CLIENT_ID:String = 'C';
		
		static public function getRemoteId(id1:int, id2:int):String
		{
			var ids:Array = [id1, id2];
			ids.sort();
			return REMOTE_PREFIX + ids[0] + '|' + ids[1];
		}
		
		public function CombatClient() 
		{
			super();
		}
		
		override public function get id():String
		{
			return CLIENT_ID;
		}
		
		override public function charDisconnect(charId:String):void
		{
			super.charDisconnect(charId);
			
			if (!combat.finished)
				new OpponentDisconnectCommand().execute();
		}
		
		public function rInitialize():void
		{
			new RobotServiceNT(onGetData).getCombatData(remoteId);
		}
		
		private function onGetData(result:Object):void
		{
			var users:Array = result.users; 
			var robots:Array = result.robots; 
			
			for (var i:int = 0; i < 2; i++)
			{
				var char:Char = new Char(users[i]);
				var robot:Robot = new Robot(robots[i]);
				var player:CombatPlayer = combat.getPlayer(char.userId);
				player.char = char;
				player.robot = robot;
			}
			
			combat.dispatchReady();
			new CheckEnergyCommand().execute();
			if (!combat.finished)
				send('svReady');
		}
		
		public function rStartAction():void 
		{
			MainView.instance.startRound();
		}
		
		public function sendAction(action:CombatActionTO):void
		{
			send('svPlayerAction', action);
		}
		
		public function rActionResult(results:Array):void 
		{
			for each (var result:CombatResultTO in results)
			{
				combat.getPlayer(result.userId).result = result;
			}
			
			new ApplyResultCommand().execute();
		}
		
		public function sendComplete():void
		{
			send('svComplete');
		}
		
		public function get combat():Combat
		{
			 return Combat.instance;
		}
	}

}