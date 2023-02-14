package com.kavalok.robotCombat
{
	import com.kavalok.char.Char;
	import com.kavalok.dto.robot.CombatActionTO;
	import com.kavalok.dto.robot.CombatResultTO;
	import com.kavalok.robots.Robot;
	
	public class CombatPlayer
	{
		public var userId:int;
		public var char:Char;
		public var robot:Robot;
		public var result:CombatResultTO;
		
		public function CombatPlayer(userId:int)
		{
			this.userId = userId;
		}
	}
}