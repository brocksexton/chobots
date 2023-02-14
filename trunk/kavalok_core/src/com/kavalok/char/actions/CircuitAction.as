package com.kavalok.char.actions
{
	import com.kavalok.Global;
	import com.kavalok.char.LocationChar;
	import com.kavalok.utils.GraphUtils;
	
	import flash.geom.Point;

	public class CircuitAction extends CharActionBase
	{
		static private const MIN_DISTANCE:Number = 50;
		
		override public function execute():void
		{
			if (_char.isUser)
			{
				Global.charManager.addModifier(modifierClass, modifierParam);
				var nextChar:LocationChar = getNextChar();
				if (nextChar)
					_location.sendCharAction(nextChar.id, CircuitAction, _parameters);
			}
		}
		
		private function getNextChar():LocationChar
		{
			var currentDistance:Number = MIN_DISTANCE;
			var currentChar:LocationChar = null;
			var userPoint:Point = _char.position;
			
			for each (var locChar:LocationChar in _location.chars)
			{
				if (locChar == _char)
					continue;
				
				var distance:Number = GraphUtils.distance(userPoint, locChar.position);
				if (distance > currentDistance)
					continue;
					
				if (locChar.hasModifier(modifierClass))
					continue;
					
				currentDistance = distance;
				currentChar = locChar;
			}
			
			if (currentChar)
				trace(_char.id, currentDistance, currentChar.id);
			
			return currentChar;
			
		}
		
		public function get modifierClass():String
		{
			 return _parameters.modifierClass;
		}
		
		public function get modifierParam():Object
		{
			 return _parameters.modifierParam;
		}
	}
}