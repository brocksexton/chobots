package com.kavalok.robots
{
	public class RobotModels
	{
		static public const DEFAULT:String = 'ModelDefault';
		static public const WAITING:String = 'ModelWaiting';
		static public const GROUPING:String = 'ModelGrouping';
		static public const BLOCK:String = 'ModelBlock';
		static public const ATTACK_TOP:String = 'ModelAttackTop';
		static public const ATTACK_MIDDLE:String = 'ModelAttackMiddle';
		static public const ATTACK_BOTTOM:String = 'ModelAttackBottom';
		static public const DAMAGE_TOP:String = 'ModelDemageTop';
		static public const DAMAGE_MIDDLE:String = 'ModelDemageMiddle';
		static public const DAMAGE_BOTTOM:String = 'ModelDemageBottom';
		static public const DESTROY:String = 'ModelDestroy';
		
		static public function getAttackModel(direction:String):String
		{
			var map:Object = {};
			map[CombatConstants.TOP] = ATTACK_TOP;
			map[CombatConstants.MIDDLE] = ATTACK_MIDDLE;
			map[CombatConstants.BOTTOM] = ATTACK_BOTTOM;
			return map[direction];
		}
		
		static public function getDemageModel(direction:String):String
		{
			var map:Object = {};
			map[CombatConstants.TOP] = DAMAGE_TOP;
			map[CombatConstants.MIDDLE] = DAMAGE_MIDDLE;
			map[CombatConstants.BOTTOM] = DAMAGE_BOTTOM;
			return map[direction];
		}
	}
}