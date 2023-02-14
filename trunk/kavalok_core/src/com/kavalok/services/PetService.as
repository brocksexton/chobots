package com.kavalok.services
{
	import com.kavalok.dto.pet.PetTO;
	
	public class PetService extends Red5ServiceBase
	{
		public function PetService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getPetItems() : void
		{
			doCall("getPetItems", arguments);
		}
		
		public function savePet(pet:PetTO):void
		{
			doCall("savePet", arguments);
		}
		
		public function saveParams(health:int, food:int, loyality:int, atHome:Boolean, sit:Boolean):void
		{
			doCall("saveParams", arguments);
		}
		
		public function disposePet():void
		{
			doCall("disposePet", arguments);
		}
		
	}
}