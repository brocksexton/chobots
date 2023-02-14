package com.kavalok.char.actions
{
	import com.kavalok.Global;
	import com.kavalok.char.Directions;
	import com.kavalok.location.LocationPet;
	import com.kavalok.pets.PetModels;
	
	import flash.events.Event;
	
	public class PetAnimation extends CharActionBase
	{
		override public function execute():void
		{
			if(_char.pet)
			{
				_char.pet.stop();
				_char.pet.setModel(modelName);
			
				_char.content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(e:Event):void
		{
			var pet:LocationPet = _char.pet;
			
			if (!pet)
			{
				_char.content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				return;
			}
			 
			if (pet.currentFrame == pet.totalFrames)
			{
				_char.content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_char.pet.setModel(PetModels.STAY, Directions.DOWN);
				
				if (_char.isUser)
					Global.petManager.isBusy = false;
			}
		}
		
		public function get modelName():String
		{
			 return _parameters.modelName;
		}
	}
}