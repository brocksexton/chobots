package com.kavalok.char.commands
{
	import com.kavalok.Global;
	
	public class MagicStuffItemRain extends StuffCommandBase
	{
		override public function apply():void
		{
			Global.charManager.magicStuffItemRain = parameters.fName;
			Global.charManager.magicStuffItemRainCount = int(parameters.count);
		}
		
		override public function restore():void
		{
			Global.charManager.magicStuffItemRain = null;
			Global.charManager.magicStuffItemRainCount = 0;
		}
	}
}