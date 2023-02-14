package com.kavalok.char.actions
{
	import com.kavalok.char.LocationChar;
	
	public class CharPropertyAction extends PropertyActionBase
	{
		override public function execute():void
		{
			doAction(_location.chars[_parameters.charId]);
		}
	}
}