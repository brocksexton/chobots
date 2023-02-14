package com.kavalok.pets.actions
{
	import com.kavalok.location.LocationPet;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.Sprite;
	
	public class JumpAction
	{
		private var _pet:LocationPet;
		private var _content:Sprite;
		
		private var _height:Number;
		
		public function JumpAction(pet:LocationPet)
		{
			_pet = pet;
			_content = pet.model;
		}
		
		public function execute():void
		{
			_height = 5 + Math.random() * 30;
			
			new SpriteTweaner(_content, {y: _content.y - _height}, _height/3, null, moveDown);
		}
		
		private function moveDown(sender:Object = null):void
		{
			new SpriteTweaner(_content, {y: _content.y + _height}, _height/3);
		}

	}
}