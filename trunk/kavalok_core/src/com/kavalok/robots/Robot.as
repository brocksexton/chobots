package com.kavalok.robots
{
	import com.kavalok.Global;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.dto.robot.RobotTO;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	public class Robot
	{
		private var _robotTO:RobotTO;
		
		public function Robot(robotTO:RobotTO)
		{
			_robotTO = robotTO;
		}
		
		public function get needRepair():Boolean
		{
			 return energy < maxEnergy;
		}
		
		public function getItem(itemId:int):RobotItemTO
		{
			return Arrays.firstByRequirement(_robotTO.items, 
				new PropertyCompareRequirement('id', itemId)) as RobotItemTO; 
		}
		
		public function get bodyItem():RobotItemTO
		{
			 return Arrays.firstByRequirement(_robotTO.items,
			 	new PropertyCompareRequirement('isBody', true)) as RobotItemTO;
		}
		
		// ------------------------------------------------- attack
		
		public function get attack():int
		{
			return baseAttack + additionalAttack;
		}
		
		public function get baseAttack():int
		{
			return calcBaseSum('attack');
		}
		
		public function get additionalAttack():int
		{
			return calcArtifactSum('attack');
		}
		
		// ------------------------------------------------- defence
		
		public function get defence():int
		{
			return baseDefence + additionalDefence;
		}
		
		public function get baseDefence():int
		{
			return calcBaseSum('defence');
		}
		
		public function get additionalDefence():int
		{
			return calcArtifactSum('defence');
		}
		
		// ------------------------------------------------- accuracy
		
		public function get accuracy():int
		{
			return baseAccuracy + additionalAccuracy;
		}
		
		public function get baseAccuracy():int
		{
			return calcBaseSum('accuracy');
		}
		
		public function get additionalAccuracy():int
		{
			return calcArtifactSum('accuracy');
		}
		
		// ------------------------------------------------- mobility
		
		public function get mobility():int
		{
			return baseMobility + additionalMobility;
		}
		
		public function get baseMobility():int
		{
			return calcBaseSum('mobility');
		}
		
		public function get additionalMobility():int
		{
			return calcArtifactSum('mobility');
		}
		
		// ------------------------------------------------- energy
		 
		public function get maxEnergy():int
		{
			var baseSum:int = calcBaseSum('energy') + RobotUtil.getEnergy(_robotTO.level) 
			
			var artifactSum:Number = 0;
			for each (var item:RobotItemTO in _robotTO.items)
			{
				if (item.isArtifact)
				{
					if (item.percent)
						artifactSum += baseSum * item.energy / 100.0;
					else
						artifactSum += item.energy;
				}
			}
			
			return baseSum + artifactSum;
		}
		
		// ------------------------------------------------- 
		
		private function calcArtifactSum(propertyName:String):int
		{
			var baseSum:int = calcBaseSum(propertyName);
			var sum:Number = 0;
			for each (var item:RobotItemTO in _robotTO.items)
			{
				if (item.isArtifact)
				{
					if (item.percent)
						sum += baseSum * item[propertyName] / 100.0;
					else
						sum += item[propertyName];
				}
			}
			return int(sum);
		}
		
		private function calcBaseSum(propertyName:String):int
		{
			var sum:int = 0;
			for each (var item:RobotItemTO in _robotTO.items)
			{
				if (item.isBaseItem)
					sum += item[propertyName];
			}
			return sum;
		}
		
		public function get artifacts():Array
		{
			 return Arrays.findByProperty(items, 'isArtifact', true);
		}
		
		public function get specialItems():Array
		{
			 return Arrays.findByProperty(items, 'isSpecialItem', true);
		}
		
		public function get robotTO():RobotTO { return _robotTO; }
		public function get level():int { return _robotTO.level; }
		public function get experience():int { return _robotTO.experience; }
		
		public function get energy():int { return _robotTO.energy; }
		public function set energy(value:int):void
		{
			 _robotTO.energy = value;
		}
		
		public function get active():Boolean { return _robotTO.active; }
		public function set active(value:Boolean):void
		{
			 _robotTO.active = value;
		}
		
		public function get id():int { return _robotTO.id; }
		public function get name():String { return _robotTO.name; }
		
		public function get items():Array { return _robotTO.items; }
		public function set items(value:Array):void
		{
			 _robotTO.items = value;
		}
		
		public function get localizedName():String
		{
			 return Global.resourceBundles.robotItems.messages[name] || name;
		}

	}
}