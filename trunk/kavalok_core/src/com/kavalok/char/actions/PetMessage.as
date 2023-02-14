package com.kavalok.char.actions
{
	import com.kavalok.Global;
	import com.kavalok.char.Directions;
	import com.kavalok.pets.PetModels;
	
	import flash.events.Event;
	
	public class PetMessage extends CharActionBase
	{
		override public function execute():void
		{
			if(!_char.pet || !Global.petManager.messages)
				return;
			
			_char.pet.stop();
			_char.pet.setModel(PetModels.STAY, Directions.DOWN);
			_char.pet.chatMessage.show(null, Global.petManager.messages[messageNum]);
		}
		
		public function get messageNum():String
		{
			 return _parameters.messageNum;
		}
	}
}