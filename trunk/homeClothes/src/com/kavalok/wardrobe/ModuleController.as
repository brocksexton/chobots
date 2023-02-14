package com.kavalok.wardrobe
{
	import com.kavalok.char.Stuffs;
	
	public class ModuleController
	{
		public function ModuleController()
		{
		}
		
		public function get module():HomeClothes
		{
			 return HomeClothes.instance;
		}

		public function get wardrobe():Wardrobe
		{
			 return HomeClothes.instance.wardrobe;
		}
		
	}
}