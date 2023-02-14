package com.kavalok.location.modifiers
{
	import com.kavalok.char.CharStates;
	import com.kavalok.char.LocationChar;
	import com.kavalok.char.Stuffs;

	public class CharBodyModifier extends LocationModifierBase
	{
		public function CharBodyModifier()
		{
			super();
		}
		
		override public function apply():void
		{
			for each (var char:LocationChar in location.chars)
			{
				onCharAdded(char);
			}
			location.charAddedEvent.addListener(onCharAdded);
		}
		
		private function onCharAdded(locChar:LocationChar):void
		{
			locChar.char.body = body;
			locChar.char.clothes = [];
			locChar.refreshModel();
		}
		
		override public function restore():void
		{
			for each (var char:LocationChar in location.chars)
			{
				var charState:Object = location.getCharState(char.id); 
				char.body = charState[CharStates.BODY];
				char.clothes = Stuffs.getClothesFromOptimized(charState[CharStates.CLOTHES]);
			}
			location.charAddedEvent.removeListener(onCharAdded);
		}
		
		public function get body():String { return parameters.body; }
	}
}