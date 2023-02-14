package com.kavalok.pets.commands
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.services.PetService;
	
	public class DisposePetCommand
	{
		public function execute():void
		{
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(
				Global.resourceBundles.pets.messages.disposeQuastion);
			dialog.yes.addListener(disposePet);
		}
		
		private function disposePet():void
		{
			Global.isLocked = true;
			new PetService(onResult).disposePet();
			Global.sendAchievement("ac34;","Abandon Pet");
		}
		
		private function onResult(result:Object):void
		{
			Global.isLocked = false;
			Global.petManager.pet = null;
		}

	}
}