package com.kavalok.char.modifiers
{
	import flash.utils.setTimeout;
	
	public class TeleportModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 200;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.teleportMode = true;
		}
		
		override protected function restore():void
		{
			_char.teleportMode = false;
		}

	}
}