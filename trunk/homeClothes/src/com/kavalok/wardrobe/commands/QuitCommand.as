package com.kavalok.wardrobe.commands
{
	import com.kavalok.Global;
	import com.kavalok.wardrobe.ModuleController;
	import com.kavalok.gameplay.frame.GameFrameView;
	
	public class QuitCommand extends ModuleController
	{
		public function QuitCommand()
		{
			super();
		}
		
		public function execute():void
		{
			Global.charManager.clothes = wardrobe.usedClothes;
			Global.charManager.stuffs.updateItems(wardrobe.updateList);
			module.closeModule();
			//Global.charManager.body = "default";
			Global.charManager.body = Global.currentBody;
		}
	}
}