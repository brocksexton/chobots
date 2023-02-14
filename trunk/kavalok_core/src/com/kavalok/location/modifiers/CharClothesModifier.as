package com.kavalok.location.modifiers
{
	import com.kavalok.Global;
	import com.kavalok.char.CharStates;
	import com.kavalok.char.LocationChar;
	import com.kavalok.char.Stuffs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.utils.ReflectUtil;

	public class CharClothesModifier extends LocationModifierBase
	{
		private var _item:StuffItemLightTO;
		
		public function CharClothesModifier()
		{
			super();
		}
		
		override public function apply():void
		{
			_item = new StuffItemLightTO();
			ReflectUtil.copyFieldsAndProperties(parameters.item, _item);
			
			for each (var char:LocationChar in location.chars)
			{
				onCharAdded(char);
			}
			location.charAddedEvent.addListener(onCharAdded);
		}
		
		private function onCharAdded(locChar:LocationChar):void
		{
			locChar.char.clothes = getModifiedClothes(locChar.id);
			locChar.refreshModel();
		}
		
		override public function restore():void
		{
			for each (var char:LocationChar in location.chars)
			{
				char.clothes = getOriginalClothes(char.id);
			}
			location.charAddedEvent.removeListener(onCharAdded);
		}
		
		private function getModifiedClothes(charId:String):Array
		{
			var result:Array = [_item];
			
			if (!replaceCurrent)
			{
				var clothes:Array = getOriginalClothes(charId);
				for each (var clothe:StuffItemLightTO in clothes)
				{
					if (Stuffs.isCompatible(clothe.placement, _item.placement))
						result.push(clothe);
				}
			}
			
			return result;
		}
		
		private function getOriginalClothes(charId:String):Array
		{
			var charState:Object = location.getCharState(charId); 
			return Stuffs.getClothesFromOptimized(charState[CharStates.CLOTHES]);
		}
		
		public function get replaceCurrent():Boolean
		{
			 return parameters.replaceCurrent;
		}
	}
}