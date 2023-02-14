package com.kavalok.pets
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.pet.PetTO;
	import com.kavalok.gameplay.commands.MoneyAnimCommand;
	import com.kavalok.services.PetService;
	
	public class SavePetCommand
	{
		private var _pet:PetTO;
		private var _resultHandler:Function;
		
		public function SavePetCommand(pet:PetTO, onSave:Function = null)
		{
			_pet = pet;
			_resultHandler = onSave;
		}
		
		public function execute():void
		{
			Global.isLocked = true;
			new PetService(onPetSaved).savePet(_pet);
		}
		
		private function onPetSaved(result:PetTO):void
		{
			Global.isLocked = false;
			
			if (result)
			{
				Global.petManager.pet = result;
				Global.charManager.stuffs.refresh();
				var dialog:DialogOkView = Dialogs.showOkDialog(messages.petAtHome);
				dialog.ok.addListener(onOk);
			}
			else
			{
				Dialogs.showOkDialog(Global.resourceBundles.pets.messages.badName);
			}
		}
		
		private function onOk():void
		{
			if (_resultHandler != null)
				_resultHandler();
		}
		
		public function get messages():Object
		{
			 return Pets.instance.bundle.messages;
		}

	}
}