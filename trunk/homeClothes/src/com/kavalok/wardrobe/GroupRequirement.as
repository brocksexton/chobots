package com.kavalok.wardrobe
{
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.interfaces.IRequirement;
	import com.kavalok.wardrobe.view.ItemSprite;

	public class GroupRequirement implements IRequirement
	{
		private var _groupNum:int
		
		public function GroupRequirement(groupNum:int)
		{
			_groupNum = groupNum;
		}

		public function meet(object:Object):Boolean
		{
			return getGroupNum(ItemSprite(object).stuff) == _groupNum;
		}
		
		private function getGroupNum(item:StuffItemLightTO):int
		{
			var placement:String = item.placement;
			
			if (checkPlacement(placement, 'HF£'))
				return 0;
			else if (checkPlacement(placement, 'MN'))
				return 1;
			else if (checkPlacement(placement, 'LBX'))
				return 2;
			else if (checkPlacement(placement, '#&I'))
				return 3;
			else
				return 4;
		}
		
		private function checkPlacement(placement:String, value:String):Boolean
		{
			for (var i:int = 0; i < placement.length; i++)
			{
				var char:String = placement.charAt(i);
				if (value.indexOf(char) == -1)
					return false;
			}
			return true;
		}
		
	}
}