package com.kavalok.char.modifiers
{
	import com.kavalok.Global;
	
	public class PromoModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 60;
		
		override public function get timeout():int
		{
			 return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_char.promotionChatMode = true;
		}
		
		override protected function restore():void
		{
			_char.promotionChatMode = false;
		}

	}
}