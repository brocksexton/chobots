package com.kavalok.char.actions
{
	import com.kavalok.char.LocationChar;
	
	public class LocationPropertyAction extends PropertyActionBase
	{
		override public function execute():void
		{
			doAction(_location);
		}
	}
}