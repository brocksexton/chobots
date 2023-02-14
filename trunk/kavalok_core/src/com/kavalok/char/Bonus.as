package com.kavalok.char
{
	import flash.events.Event;
	
	public class Bonus
	{
		private var _anim:McBonusAnim;
		private var _char:LocationChar;
		
		public function Bonus(char:LocationChar, value:int)
		{
			_char = char;
			_anim = new McBonusAnim();
			_anim.addEventListener(Event.COMPLETE, removeAnim);
			_anim.mcBonus.txtField.text = value.toString();
			_anim.y = -_char.model.height;
			_char.content.addChild(_anim);
		}
		
		public function removeAnim(e:Event):void
		{
			_anim.stop();
			_char.content.removeChild(_anim);
		}
		
	}
	
}