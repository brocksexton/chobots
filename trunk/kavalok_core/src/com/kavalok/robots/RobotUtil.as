package com.kavalok.robots
{
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class RobotUtil
	{
		static public function getEnergy(level:int):int
		{
			return 5 * (level - 1);
		}
		
		static public function getExperience(level:int):int
		{
			var L:int = level - 1;
			return 3 * L*L*L + 10 * L*L + 5 * L;
		}
		
		static public function getEarnedExp(targetDamage:int):int
		{
			return Math.max(0.1 * targetDamage, 1);
		}
		
		static public function getRepairCost(level:int):int
		{
			return level * 100;
		}
		
		static public function getEarnedMoney(level:int):int
		{
			return int(0.5 * getRepairCost(level));
		}
	}
}