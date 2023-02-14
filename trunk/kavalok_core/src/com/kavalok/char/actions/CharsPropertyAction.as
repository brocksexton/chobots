package com.kavalok.char.actions
{
	import com.kavalok.char.LocationChar;
	
	public class CharsPropertyAction extends PropertyActionBase
	{
		override public function execute():void
		{
			for each (var object:Object in _location.chars)
			{
				doAction(object);
			}
		}
	}
}