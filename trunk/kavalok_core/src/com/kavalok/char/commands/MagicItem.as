package com.kavalok.char.commands
{
	import com.kavalok.Global;
	
	public class MagicItem extends StuffCommandBase
	{
		override public function apply():void
		{
			Global.charManager.magicItem = parameters.name;
		}
		
		override public function restore():void
		{
			Global.charManager.magicItem = null;
		}
	}
}