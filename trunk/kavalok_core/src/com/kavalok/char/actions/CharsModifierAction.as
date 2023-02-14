package com.kavalok.char.actions
{
	import com.kavalok.Global;
	
	public class CharsModifierAction extends CharActionBase
	{
		override public function execute():void
		{
			var clasName:String = 'com.kavalok.char.modifiers::' + _parameters.className; 
			Global.charManager.addModifier(clasName, {});
		}
	}
}