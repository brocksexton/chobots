package com.kavalok.char.commands
{
	import com.kavalok.Global;
	
	public class MusicInstrument extends StuffCommandBase
	{
		override public function apply():void
		{
			Global.charManager.instrument = parameters.name;
		}
		
		override public function restore():void
		{
			Global.charManager.instrument = null;
		}
	}
}